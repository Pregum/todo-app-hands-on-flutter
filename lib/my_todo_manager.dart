import 'dart:math';

import 'package:todo_app/my_todo_box.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

import 'my_observer.dart';
import 'my_todo.dart';

/// todoタスクを管理するクラス
class MyTodoManager {
  static MyTodoManager? _ins;

  /// 内部で保持しているtodoリスト
  final List<MyTodo> _todos = [];

  /// todoリストの個数を返すプロパティ
  get taskLength => _todos.length;

  /// 更新通知を届けるリスナー
  final List<MyObserver<List<MyTodo>>> _listeners = [];

  /// boxを操作するオブジェクト
  final _todoService = MyTodoBox.instance;

  /// 外部からこのクラスを呼ぶ際に使用する静的プロパティ
  static MyTodoManager get instance => _ins ?? MyTodoManager._getInstance();

  /// インナーコンストラクタ
  MyTodoManager._internal();

  /// インナーファクトリコンストラクタ
  ///
  /// [ _ins ]がnullならば、代入処理が走ります。
  factory MyTodoManager._getInstance() {
    return _ins ??= MyTodoManager._internal();
  }

  /// 更新通知を飛ばすリスナーを追加します。
  void addListener(MyObserver<List<MyTodo>> listener) {
    _listeners.add(listener);
  }

  /// 更新通知を飛ばすリスナーを全削除します。
  void clearListenrs() {
    _listeners.clear();
  }

  /// [ todo ] をboxから削除します。
  ///
  /// 削除したら削除後のリストを通知します。
  Future<void> deleteTodo(MyTodo todo) async {
    _todos.removeWhere((element) => element.id == todo.id);
    await _todoService.delete(todo);
    _notifyonReceiveListeners(_todos);
  }

  /// idが一意であるかチェックします。
  ///
  /// 一意なら[true], 一意でなければ[false]を返します。
  bool _verifyUniqueId(String id) {
    return _todos.any((todo) => todo.id == id);
  }

  /// 新しいタスクを作成します。
  ///
  /// このメソッドだけではboxへは保存されません。
  ///
  /// boxへ保存する場合は[storeTodo]メソッドで保存してください。
  ///
  /// 作成後、 [onCreate] 作成通知が飛びます。
  Future<void> createNewTodo() async {
    const uuid = Uuid();
    var newId = uuid.v4();
    while (_verifyUniqueId(newId)) {
      newId = uuid.v4();
    }
    final now = DateTime.now();
    final newTodo = MyTodo(
      isCompleted: false,
      taskName: 'new todo',
      id: newId,
      createdAt: now,
      udatedAt: now,
    );
    _notifyCreateListeners([newTodo]);
  }

  /// [item] と同じidを持つオブジェクトをboxの中から探して更新します。
  ///
  /// 一致するオブジェクトがない場合、更新処理は実行されません。
  Future<void> updateTodo(MyTodo item) async {
    final target = _todos.firstWhereOrNull((todo) => todo.id == item.id);
    if (target == null) {
      return;
    }
    target.updatedAt = DateTime.now();
    await _todoService.set(item);
    _notifyonReceiveListeners(_todos);
  }

  /// [index]の位置に削除された[todo]を元に戻します。
  Future<void> restoreTodo(int index, MyTodo todo) async {
    var correctedIndex = index;
    if (index < 0) {
      return;
    } else if (_todos.length < index) {
      correctedIndex = max(0, _todos.length);
    }

    _todos.insert(correctedIndex, todo);
    await _todoService.set(todo);
    _notifyonReceiveListeners(_todos);
  }

  /// [index]の位置に[todo]を保存します。
  ///
  /// [restoreTodo]とのユースケースの違いは新規作成時か元に戻す処理かです。
  Future<void> storeTodo(int index, MyTodo todo) async {
    if (index < 0 || _todos.length < index) {
      return;
    }

    _todos.insert(index, todo);
    todo.updatedAt = DateTime.now();
    await _todoService.set(todo);
    _notifyonReceiveListeners(_todos);
  }

  /// boxから全てのtodoタスクを取得します。
  Future<Iterable<MyTodo>> getAll() async {
    final todos = await _todoService.getAll();
    todos.sorted(((a, b) => a.createdAt.compareTo(b.createdAt)));
    _todos.addAll(todos);
    return todos;
  }

  /// リスナーに更新処理を通知します。
  void _notifyonReceiveListeners(List<MyTodo> items) {
    for (var listener in _listeners) {
      listener.onReceive(items);
    }
  }

  /// リスナーに作成通知を行います。
  void _notifyCreateListeners(List<MyTodo> items) {
    for (var listener in _listeners) {
      listener.onCreate(items);
    }
  }
}
