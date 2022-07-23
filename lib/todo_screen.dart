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
      return ListView.builder(
          itemBuilder: (context, index) {
            final currentContent = contents[index];
            return CheckboxListTile(
              value: currentContent.isCompleted,
              onChanged: (bool? value) {
                if (value == null) {
                  return;
                }

                setState(() => currentContent.isCompleted = value);
              },
              title: Text(currentContent.taskName),
            );
          },
          itemCount: contents.length);
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
