import 'package:flutter/material.dart';
import 'package:todo_app/my_utils.dart';
import 'package:todo_app/todo.dart';

import 'todo_manager.dart';

typedef FetchFunc = T Function<T>();

/// 非同期でTodoタスクのデータを取得するウィジェットです。
///
/// 取得中はロードアニメーションが表示されます。
class MyLoadingTodoWidget extends StatefulWidget {
  const MyLoadingTodoWidget({
    Key? key,
    required this.onCompleted,
    required this.builder,
  }) : super(key: key);
  final Function(List<Todo> todos) onCompleted;
  final Widget Function(List<Todo> todos) builder;

  @override
  State<MyLoadingTodoWidget> createState() => _MyLoadingTodoWidgetState();
}

class _MyLoadingTodoWidgetState extends State<MyLoadingTodoWidget>
    with MyUtils {
  late final Future<List<Todo>> future;

  @override
  void initState() {
    super.initState();
    future = _fetchContents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = snapshot.data;
        if (todos == null || todos.isEmpty) {
          return const Center(
            child: Text('タスクを追加しましょう！'),
          );
        }

        return widget.builder(snapshot.data!);
      },
      future: future,
    );
  }

  Future<List<Todo>> _fetchContents() async {
    final todos = await TodoManager.instance.getAll();
    final listTodos = todos.toList();
    widget.onCompleted(listTodos);
    return listTodos;
  }
}
