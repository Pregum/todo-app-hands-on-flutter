import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/my_utils.dart';
import 'package:todo_app/my_todo.dart';

import 'my_observer.dart';
import 'my_todo_manager.dart';

typedef FetchFunc = T Function<T>();

/// 非同期でTodoタスクのデータを取得するウィジェットです。
///
/// 取得中はロードアニメーションが表示されます。
class MyLoadingTodoWidget extends StatefulWidget {
  const MyLoadingTodoWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);
  final Widget Function(Iterable<MyTodo> todos) builder;

  @override
  State<MyLoadingTodoWidget> createState() => _MyLoadingTodoWidgetState();
}

class _MyLoadingTodoWidgetState extends State<MyLoadingTodoWidget>
    with MyUtils
    implements MyObserver<Iterable<MyTodo>> {
  final _sc = StreamController<Iterable<MyTodo>>();

  @override
  void initState() {
    super.initState();
    MyTodoManager.instance.addListener(this);
    _initStream();
  }

  Future<void> _initStream() async {
    final todos = await MyTodoManager.instance.getAll();
    _sc.sink.add(todos);
  }

  @override
  void dispose() {
    MyTodoManager.instance.clearListenrs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<Iterable<MyTodo>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final todos = snapshot.data;
        if (todos == null || todos.isEmpty) {
          return const Center(
            child: Text('タスクを追加しましょう！'),
          );
        }

        return widget.builder(snapshot.data!);
      },
      stream: _sc.stream,
    );
  }

  @override
  void onReceive(Iterable<MyTodo> item) {
    _sc.sink.add(item);
  }

  @override
  Future<void> onCreate(Iterable<MyTodo> item) async {
    if (item.isEmpty) {
      return;
    }
    await showEditingTodoDialog(context, item.first, newItem: true);
  }
}
