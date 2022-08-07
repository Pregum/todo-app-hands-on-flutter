import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/todo.dart';

class TodoService {
  final _boxName = 'todo';
  static const fiexedId = 1;
  static TodoService? _ins;

  static TodoService get instance => _ins ??= TodoService._getInstance();

  TodoService._internal();
  factory TodoService._getInstance() {
    return _ins ??= TodoService._internal();
  }

  Future<Iterable<Todo>> getAll() async {
    final box = await _openBoxIfClosed();
    return box.values;
  }

  Future<int> add(Todo value) async {
    final box = await _openBoxIfClosed();
    final id = await box.add(value);
    return id;
  }

  Future<void> delete(Todo value) async {
    final box = await _openBoxIfClosed();
    await box.delete(value.id);
  }

  Future<Todo> set(Todo value) async {
    final box = await _openBoxIfClosed();
    await box.put(value.id, value);
    return value;
  }

  Future<int> clearAll() async {
    final box = await _openBoxIfClosed();
    final clearLength = await box.clear();
    return clearLength;
  }

  Future<Box<Todo>> _openBoxIfClosed() async {
    final isOpen = Hive.isBoxOpen(_boxName);
    final box =
        isOpen ? Hive.box<Todo>(_boxName) : await Hive.openBox<Todo>(_boxName);
    return box;
  }
}
