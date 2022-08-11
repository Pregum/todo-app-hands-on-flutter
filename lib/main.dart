import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/my_todo.dart';
import 'package:todo_app/my_todo_manager.dart';

import 'todo_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hiveのデータ取得するまでは読み込み画面を出す。.
  // ref: https://github.com/rrousselGit/riverpod/issues/329#issuecomment-879099371
  // Show a progress indicator while awaiting things
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    ),
  );

  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final sc = StreamController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const TodoPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _createNewContent();
        },
        tooltip: '新しいタスク',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _createNewContent() async {
    await MyTodoManager.instance.createNewTodo();
  }
}
