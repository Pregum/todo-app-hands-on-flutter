import 'package:flutter/material.dart';

import 'observer.dart';
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
          return const CircularProgressIndicator();
        }

        return _buildListContents(snapshot.data);
      },
      future: _fetchContents(),
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
              return Dismissible(
                key: Key(currentContent.id),
                onDismissed: (direction) {
                  TodoManager.getInstance().deleteTodo(index);
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
                    onLongPress: !currentContent.isCompleted
                        ? () {
                            setState(() => currentContent.isEditEnabled = true);
                          }
                        : null,
                    child: CheckboxListTile(
                      value: currentContent.isCompleted,
                      onChanged: (bool? value) {
                        if (value == null) {
                          return;
                        }

                        setState(() => currentContent.isCompleted = value);
                      },
                      title: currentContent.isEditEnabled
                          ? TextField(
                              onChanged: (value) => setState(
                                  () => currentContent.taskName = value),
                            )
                          : Text(currentContent.taskName,
                              style: currentContent.isCompleted
                                  ? const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                    )
                                  : null),
                    ),
                  ),
                ),
              );
            },
            itemCount: contents.length),
      );
    }
  }

  Future<List<Todo>> _fetchContents() async {
    return _editTodos;
  }

  void createNewContent() {
    TodoManager.getInstance().createNewTodo();
  }

  @override
  void onReceive(List<Todo> items) {
    setState(() => _editTodos = items);
  }
}
