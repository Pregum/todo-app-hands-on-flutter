import 'dart:math';

import 'package:todo_app/todo_box.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

import 'observer.dart';
import 'todo.dart';

class TodoManager {
  static TodoManager? _ins;

  /// 内部で保持しているtodoリスト
  final List<Todo> _todos = [];

  /// 更新通知を届けるリスナー
  final List<Observer<List<Todo>>> _listeners = [];

  final _todoService = TodoBox.instance;

  static TodoManager get instance => _ins ?? TodoManager._getInstance();

  TodoManager._internal();
  factory TodoManager._getInstance() {
    return _ins ??= TodoManager._internal();
  }

  void addListener(Observer<List<Todo>> listener) {
    _listeners.add(listener);
  }

  void clearListenrs() {
    _listeners.clear();
  }

  Future<void> deleteTodo(Todo todo) async {
    _todos.removeWhere((element) => element.id == todo.id);
    await _todoService.delete(todo);
    _notifyListeners(_todos);
  }

  bool _verifyUniqueId(String id) {
    return _todos.any((todo) => todo.id == id);
  }

  Future<void> createNewTodo() async {
    const uuid = Uuid();
    var newId = uuid.v4();
    while (_verifyUniqueId(newId)) {
      newId = uuid.v4();
    }
    final now = DateTime.now();
    final newTodo = Todo(
      isCompleted: false,
      taskName: 'new todo',
      id: newId,
      createdAt: now,
      udatedAt: now,
    );
    _todos.add(newTodo);
    await _todoService.set(newTodo);
    _notifyListeners(_todos);
    _notifyCreationListeners([newTodo]);
  }

  Future<void> updateTodo(Todo item) async {
    final target = _todos.firstWhereOrNull((todo) => todo.id == item.id);
    if (target == null) {
      return;
    }
    target.updatedAt = DateTime.now();
    await _todoService.set(item);
    _notifyListeners(_todos);
  }

  Future<void> restoreTodo(int index, Todo todo) async {
    var correctedIndex = index;
    if (index < 0) {
      return;
    } else if (_todos.length <= index) {
      correctedIndex = max(0, _todos.length - 1);
    }

    _todos.insert(correctedIndex, todo);
    await _todoService.set(todo);
    _notifyListeners(_todos);
  }

  Future<void> storeTodo(int index, Todo todo) async {
    if (index < 0 || _todos.length <= index) {
      return;
    }

    _todos.insert(index, todo);
    todo.updatedAt = DateTime.now();
    await _todoService.set(todo);
    _notifyListeners(_todos);
  }

  Future<Iterable<Todo>> getAll() async {
    final todos = await _todoService.getAll();
    todos.sorted(((a, b) => a.createdAt.compareTo(b.createdAt)));
    _todos.addAll(todos);
    return todos;
  }

  void _notifyListeners(List<Todo> items) {
    for (var listener in _listeners) {
      listener.onReceive(items);
    }
  }

  void _notifyCreationListeners(List<Todo> items) {
    for (var listener in _listeners) {
      listener.onCreation(items);
    }
  }
}
