import 'package:flutter/material.dart';
import 'package:todo_app/my_loading_widget.dart';

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
    return MyLoadingTodoWidget(
      onCompleted: (todos) {
        setState(() => _editTodos = todos);
      },
      builder: ((todos) {
        return _buildListContents(_editTodos);
      }),
    );
  }

  Widget _buildListContents(List<Todo> todos) {
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
