import 'package:flutter/material.dart';

import 'observer.dart';
import 'todo_tile_widget.dart';
import 'todo.dart';
import 'todo_manager.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    implements Observer<List<Todo>> {
  List<Todo> _editTodos = <Todo>[];
  late final future = _fetchContents();

  @override
  void initState() {
    super.initState();
    TodoManager.getInstance().addListener(this);
  }

  @override
  void dispose() {
    TodoManager.getInstance().clearListenrs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildListContents(_editTodos);
      },
      future: future,
    );
  }

  Widget _buildListContents(List<Todo>? contents) {
    if (contents == null || contents.isEmpty) {
      return const Center(child: Text('タスクを追加しましょう！'));
    } else {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          TodoManager.getInstance().updateEditEnabled();
        },
        child: ListView.builder(
            itemBuilder: (context, index) {
              final currentContent = contents[index];
              return TodoTileWidget(
                todo: currentContent,
                onDismiss: () async {
                  await TodoManager.getInstance()
                      .deleteTodo(currentContent, false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${currentContent.taskName}は削除されました。'),
                        ],
                      ),
                      action: SnackBarAction(
                        label: '元へ戻す',
                        onPressed: () {
                          TodoManager.getInstance()
                              .insertTodo(index, currentContent);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('元へ戻しました'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: contents.length),
      );
    }
  }

  Future<List<Todo>> _fetchContents() async {
    final todos = await TodoManager.getInstance().getAll();
    setState(() => _editTodos = todos.toList());
    return _editTodos;
  }

  @override
  void onReceive(List<Todo> items) {
    setState(() => _editTodos = items);
  }
}
