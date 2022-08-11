import 'package:flutter/material.dart';
import 'package:todo_app/my_loading_widget.dart';

import 'my_observer.dart';
import 'my_utils.dart';
import 'todo_tile_widget.dart';
import 'my_todo.dart';
import 'my_todo_manager.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>
    with MyUtils
    implements MyObserver<List<MyTodo>> {
  List<MyTodo> _editTodos = <MyTodo>[];
  final _todoManager = MyTodoManager.instance;

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
      onCompletedFetching: (todos) {
        setState(() => _editTodos = todos);
      },
      builder: ((todos) {
        return _buildListContents(_editTodos);
      }),
    );
  }

  Widget _buildListContents(List<MyTodo> todos) {
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

  @override
  void onReceive(List<MyTodo> todos) {
    setState(() => _editTodos = todos);
  }

  @override
  Future<void> onCreate(List<MyTodo> item) async {
    if (item.isEmpty) {
      return;
    }
    await showEditingTodoDialog(context, item.first, newItem: true);
  }
}
