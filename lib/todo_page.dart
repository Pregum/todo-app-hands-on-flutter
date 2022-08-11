import 'package:flutter/material.dart';

import 'my_observer.dart';
import 'my_utils.dart';
import 'todo_tile_widget.dart';
import 'todo.dart';
import 'todo_manager.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>
    with MyUtils
    implements MyObserver<List<Todo>> {
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
              showDeletedTodoSnackBar(context, currentTodo, index);
            },
            onLongTap: () async {
              await showEditingTodoDialog(context, currentTodo, newItem: false);
            },
          );
        },
        itemCount: todos.length,
      );
    }
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
    await showEditingTodoDialog(context, item.first, newItem: true);
  }
}
