import 'package:todo_app/todo_service.dart';
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

  /// 編集中の [Todo]
  ///
  /// 編集中のtodoがない場合は [null] が入ります。
  Todo? _editingTodo;

  final _todoService = TodoService.getInstance();

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
      await _todoService.set(todo);
    }
    _editingTodo = null;

    _notifyListeners(_todos);
  }

  Future<void> deleteTodo(Todo todo, bool needNotify) async {
    _todos.removeWhere((element) => element.id == todo.id);
    if (_editingTodo?.id == todo.id) {
      _editingTodo = null;
    }
    await _todoService.delete(todo);
    if (needNotify) {
      _notifyListeners(_todos);
    }
  }

  bool _verifyUniqueId(String id) {
    return _todos.any((todo) => todo.id == id);
  }

  Future<void> createNewTodo({required Function() onFailed}) async {
    if (_editingTodo != null) {
      onFailed();
      return;
    }

    const uuid = Uuid();
    var newId = uuid.v4();
    while (_verifyUniqueId(newId)) {
      newId = uuid.v4();
    }
    final now = DateTime.now();
    final newTodo = Todo(
      isCompleted: false,
      taskName: 'new todo',
      isEditEnabled: true,
      id: newId,
      createdAt: now,
      udatedAt: now,
    );
    _todos.add(newTodo);
    await _todoService.set(newTodo);
    _editingTodo = newTodo;
    _notifyListeners(_todos);
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

  Future<void> startEdit(Todo item) async {
    final target = _todos.firstWhereOrNull((todo) => todo.id == item.id);
    if (target == null) {
      return;
    }

    target.isEditEnabled = true;
    target.updatedAt = DateTime.now();
    _editingTodo = target;
    await _todoService.set(target);
    _notifyListeners(_todos);
  }

  Future<void> finishEdit(Todo item) async {
    final target = _todos.firstWhereOrNull((todo) => todo.id == item.id);
    if (target == null) {
      return;
    }

    target.isEditEnabled = false;
    target.updatedAt = DateTime.now();
    if (_editingTodo?.id == target.id) {
      _editingTodo = null;
    }
    await _todoService.set(target);
    _notifyListeners(_todos);
  }

  Future<void> insertTodo(int index, Todo todo) async {
    if (index < 0 || _todos.length <= index) {
      return;
    }

    _todos.insert(index, todo);
    todo.updatedAt = DateTime.now();
    await _todoService.set(todo);
    _notifyListeners(_todos);
  }

  Future<Iterable<Todo>> getAll() async {
    final todos = await _todoService.getAll()
      ..sorted(((a, b) => a.createdAt.compareTo(b.createdAt)));
    _todos.addAll(todos);
    return todos;
  }

  void _notifyListeners(List<Todo> items) {
    for (var listener in _listeners) {
      listener.onReceive(items);
    }
  }
}
