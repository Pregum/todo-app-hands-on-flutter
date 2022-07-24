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
  final _todoManager = TodoManager.getInstance();

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
      child: Material(
        child: InkWell(
          onLongPress: !widget.todo.isCompleted
              ? () async {
                  await _todoManager.startEdit(widget.todo);
                }
              : null,
          child: CheckboxListTile(
            value: widget.todo.isCompleted,
            onChanged: (bool? value) async {
              if (value == null) {
                return;
              }
              widget.todo.isCompleted = value;
              await _todoManager.updateTodo(widget.todo);
            },
            title: widget.todo.isEditEnabled
                ? TextField(
                    autofocus: widget.todo.isEditEnabled,
                    onChanged: (value) async {
                      widget.todo.taskName = _textEditingController.text;
                      await _todoManager.updateTodo(widget.todo);
                    },
                    onSubmitted: (text) async {
                      widget.todo.taskName = _textEditingController.text;
                      await _todoManager.finishEdit(widget.todo);
                    },
                    controller: _textEditingController,
                  )
                : Text(
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
    );
  }
}
