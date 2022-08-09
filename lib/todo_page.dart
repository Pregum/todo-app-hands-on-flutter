import 'package:flutter/material.dart';

import 'my_observer.dart';
import 'todo_tile_widget.dart';
import 'todo.dart';
import 'todo_manager.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> implements MyObserver<List<Todo>> {
  List<Todo> _editTodos = <Todo>[];
  late final future = _fetchContents();
  final _todoManager = TodoManager.instance;

  @override
  void initState() {
    super.initState();
    _todoManager.addListener(this);
  }

  @override
  void dispose() {
    _todoManager.clearListenrs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildListContents(_editTodos);
      },
      future: future,
    );
  }

  Widget _buildListContents(List<Todo>? todos) {
    if (todos == null || todos.isEmpty) {
      return const Center(
        child: Text('タスクを追加しましょう！'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          final currentTodo = todos[index];
          return TodoTileWidget(
            todo: currentTodo,
            onDismiss: () async {
              await _todoManager.deleteTodo(currentTodo);
              _showSnackbar(context, currentTodo, index);
            },
            onLongTap: () async {
              await _showTaskDialog(currentTodo, newItem: false);
            },
          );
        },
        itemCount: todos.length,
      );
    }
  }

  void _showSnackbar(BuildContext context, Todo currentTodo, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${currentTodo.taskName}は削除されました。'),
        duration: const Duration(milliseconds: 1500),
        action: SnackBarAction(
          label: '元へ戻す',
          onPressed: () async {
            await _todoManager.restoreTodo(index, currentTodo);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('元へ戻しました。'),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ダイアログを表示します。
  Future<void> _showTaskDialog(Todo todo, {bool newItem = false}) async {
    final textController = TextEditingController(text: todo.taskName);
    return showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('タスク名の編集'),
          content: TextField(
            autofocus: true,
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'タスク名を入力',
            ),
            onSubmitted: (value) async {
              if (value.isEmpty) {
                return;
              }
              Navigator.of(context).pop();
              todo.taskName = textController.text;
              if (newItem) {
                await _todoManager.storeTodo(_todoManager.taskLength, todo);
              } else {
                await _todoManager.updateTodo(todo);
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                todo.taskName = textController.text;
                if (newItem) {
                  await _todoManager.storeTodo(_todoManager.taskLength, todo);
                } else {
                  await _todoManager.updateTodo(todo);
                }
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
      context: context,
    );
  }

  Future<List<Todo>> _fetchContents() async {
    final todos = await TodoManager.instance.getAll();
    setState(() => _editTodos = todos.toList());
    return _editTodos;
  }

  @override
  void onReceive(List<Todo> todos) {
    setState(() => _editTodos = todos);
  }

  @override
  Future<void> onCreate(List<Todo> item) async {
    if (item.isEmpty) {
      return;
    }
    await _showTaskDialog(item.first, newItem: true);
  }
}
