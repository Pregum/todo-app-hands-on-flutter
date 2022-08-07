import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_manager.dart';

class TodoTileWidget extends StatefulWidget {
  final Todo todo;
  final Function()? onDismiss;
  const TodoTileWidget({Key? key, required this.todo, this.onDismiss})
      : super(key: key);

  @override
  State<TodoTileWidget> createState() => _TodoTileWidgetState();
}

class _TodoTileWidgetState extends State<TodoTileWidget> {
  final _textEditingController = TextEditingController();
  final _todoManager = TodoManager.instance;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.todo.taskName;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.todo.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        widget.onDismiss?.call();
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red[500],
        child: const Icon(
          Icons.delete,
          color: Colors.black,
        ),
      ),
      child: Card(
        child: Material(
          child: InkWell(
            onLongPress: () async {
              _showDialog(widget.todo);
            },
            child: CheckboxListTile(
              value: widget.todo.isCompleted,
              onChanged: (bool? value) async {
                if (value == null) {
                  return;
                }
                widget.todo.isCompleted = value;
                await _todoManager.updateTodo(widget.todo);
              },
              title: Text(
                widget.todo.taskName,
                style: widget.todo.isCompleted
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.double,
                      )
                    : null,
              ),
              subtitle: Text('更新日: ${widget.todo.prettyUpdateAt}'),
            ),
          ),
        ),
      ),
    );
  }

  /// ダイアログを表示します。
  Future<void> _showDialog(Todo todo) async {
    final textController = TextEditingController(text: todo.taskName);
    return showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('タスク名の編集'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'タスク名を入力',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                todo.taskName = textController.text;
                await _todoManager.updateTodo(todo);
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
