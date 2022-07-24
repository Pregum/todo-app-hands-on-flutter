import 'package:todo_app/todo_service.dart';
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

  Future<void> updateEditEnabled() async {
    for (var todo in _todos) {
      todo.isEditEnabled = false;
      await TodoService.getInstance().set(todo);
    }

    _notifyListeners(_todos);
  }

  Future<void> deleteTodo(Todo todo, bool needNotify) async {
    _todos.removeWhere((element) => element.id == todo.id);
    await TodoService.getInstance().delete(todo);
    if (needNotify) {
      _notifyListeners(_todos);
    }
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
    final newTodo = Todo(
        isCompleted: false,
        taskName: 'new todo',
        isEditEnabled: true,
        id: newId);
    _todos.add(newTodo);
    print('new _todos: ${_todos}');
    await TodoService.getInstance().set(newTodo);
    _notifyListeners(_todos);
  }

  Future<void> updateTodo(Todo item) async {
    await TodoService.getInstance().set(item);
  }

  Future<void> insertTodo(int index, Todo todo) async {
    if (index < 0 || _todos.length <= index) {
      return;
    }

    _todos.insert(index, todo);
    await TodoService.getInstance().set(todo);
    _notifyListeners(_todos);
  }

  Future<Iterable<Todo>> getAll() async {
    final todos = await TodoService.getInstance().getAll();
    _todos.addAll(todos);
    print('todos: $_todos');
    return todos;
  }

  void _notifyListeners(List<Todo> items) {
    for (var listener in _listeners) {
      listener.onReceive(items);
    }
  }
}
