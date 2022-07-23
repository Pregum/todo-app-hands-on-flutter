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

  void createNewTodo() {
    final newTodo = Todo(isCompleted: false, taskName: 'new todo');
    _todos.add(newTodo);
    _notifyListeners(_todos);
  }

  void _notifyListeners(List<Todo> items) {
    for (var listener in _listeners) {
      listener.onReceive(items);
    }
  }
}
