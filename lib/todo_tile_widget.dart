import 'package:flutter/material.dart';

import 'my_todo_tile_wrapper.dart';
import 'todo.dart';
import 'todo_manager.dart';

class TodoTileWidget extends StatefulWidget {
  final Todo todo;
  final Function()? onDismiss;
  final Function()? onLongTap;
  const TodoTileWidget({
    Key? key,
    required this.todo,
    this.onDismiss,
    this.onLongTap,
  }) : super(key: key);

  @override
  State<TodoTileWidget> createState() => _TodoTileWidgetState();
}

class _TodoTileWidgetState extends State<TodoTileWidget> {
  final _todoManager = TodoManager.instance;

  @override
  Widget build(BuildContext context) {
    return MyTodoTileWrapper(
      todo: widget.todo,
      onDismiss: () {
        widget.onDismiss?.call();
      },
      onLongTap: () {
        widget.onLongTap?.call();
      },
      child: Card(
        child: CheckboxListTile(
          value: widget.todo.isCompleted,
          onChanged: (bool? newValue) async {
            if (newValue == null) {
              return;
            }
            widget.todo.isCompleted = newValue;
            await _todoManager.updateTodo(widget.todo);
          },
          title: Text(
            widget.todo.taskName,
            style: widget.todo.isCompleted
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text('更新日: ${widget.todo.prettyUpdateAt}'),
        ),
      ),
    );
  }
}
