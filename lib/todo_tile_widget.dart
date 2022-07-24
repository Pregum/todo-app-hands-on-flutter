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
              ? () {
                  setState(() => widget.todo.isEditEnabled = true);
                }
              : null,
          child: CheckboxListTile(
            value: widget.todo.isCompleted,
            onChanged: (bool? value) async {
              if (value == null) {
                return;
              }

              setState(() => widget.todo.isCompleted = value);
              await TodoManager.getInstance().updateTodo(widget.todo);
            },
            title: widget.todo.isEditEnabled
                ? TextField(
                    autofocus: widget.todo.isEditEnabled,
                    onChanged: (value) async {
                      setState(() => widget.todo.taskName = value);
                      await TodoManager.getInstance().updateTodo(widget.todo);
                    },
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
          ),
        ),
      ),
    );
  }
}
