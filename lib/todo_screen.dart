import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'observer.dart';
import 'todo_tile_widget.dart';
import 'todo.dart';
import 'todo_manager.dart';

class TodoScreen extends StatefulWidget {
  final Stream? addTodoStream;
  const TodoScreen({Key? key, this.addTodoStream}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    implements Observer<List<Todo>> {
  List<Todo> _editTodos = <Todo>[];
  late final future = _fetchContents();
  final _todoManager = TodoManager.instance;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _todoManager.addListener(this);
    widget.addTodoStream?.listen((event) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      });
    });
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
      return const Center(child: Text('タスクを追加しましょう！'));
    } else {
      return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          await _todoManager.updateEditEnabled();
        },
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final currentTodo = todos[index];
            return TodoTileWidget(
              todo: currentTodo,
              onDismiss: () async {
                await _todoManager.deleteTodo(currentTodo, true);
                _showSnackbar(context, currentTodo, index);
              },
            );
          },
          itemCount: todos.length,
        ),
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
            await _todoManager.insertTodo(index, currentTodo);
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

  Future<List<Todo>> _fetchContents() async {
    final todos = await TodoManager.instance.getAll();
    setState(() => _editTodos = todos.toList());
    return _editTodos;
  }

  @override
  void onReceive(List<Todo> todos) {
    setState(() => _editTodos = todos);
  }
}
