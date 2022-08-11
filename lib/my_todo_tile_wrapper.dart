import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';

class MyTodoTileWrapper extends StatelessWidget {
  final Widget child;
  final Todo todo;
  final Function()? onDismiss;
  final Function()? onLongTap;
  const MyTodoTileWrapper({
    Key? key,
    required this.child,
    required this.todo,
    this.onDismiss,
    this.onLongTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onLongTap?.call();
      },
      child: Dismissible(
        key: Key(todo.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          onDismiss?.call();
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
        child: child,
      ),
    );
  }
}
