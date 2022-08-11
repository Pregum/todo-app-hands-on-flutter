import 'package:flutter/material.dart';
import 'package:todo_app/my_todo.dart';
import 'package:todo_app/my_todo_manager.dart';

mixin MyUtils {
  final _todoManager = MyTodoManager.instance;

  /// 削除通知をスナックバーUIで表示します。
  void showDeletedTodoSnackBar(
      BuildContext context, MyTodo currentTodo, int index) {
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

  /// タスク名の編集ダイアログを表示します。
  Future<void> showEditingTodoDialog(BuildContext context, MyTodo todo,
      {bool newItem = false}) async {
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
}
