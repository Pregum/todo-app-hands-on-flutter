import 'package:uuid/uuid.dart';

import 'observer.dart';
import 'todo.dart';

class TodoManager {
  static TodoManager? _ins;

  final List<Todo> _todos = [];

  final List<Observer<List<Todo>>> _listeners = [];

  TodoManager._internal();
  factory TodoManager.getInstance() {
    return _ins ??= TodoManager._internal();
  }

  void addListener(Observer<List<Todo>> listener) {
    _listeners.add(listener);
  }

  void clearListenrs() {
    _listeners.clear();
  }

  void updateEditEnabled() {
    for (var todo in _todos) {
      todo.isEditEnabled = false;
    }

    _notifyListeners(_todos);
  }

  void deleteTodo(int index) {
    if (index < 0 || _todos.length <= index) {
      return;
    }
    _todos.removeAt(index);
    _notifyListeners(_todos);
  }

  bool _verifyUniqueId(String id) {
    return _todos.any((todo) => todo.id == id);
  }

  void createNewTodo() {
    const uuid = Uuid();
    var newId = uuid.v4();
    while (_verifyUniqueId(newId)) {
      newId = uuid.v4();
    }
    final newTodo = Todo(
        isCompleted: false,
        taskName: 'new todo',
        isEditEnabled: true,
        id: newId);
    _todos.add(newTodo);
    _notifyListeners(_todos);
  }

  void _notifyListeners(List<Todo> items) {
    for (var listener in _listeners) {
      listener.onReceive(items);
    }
  }
}
