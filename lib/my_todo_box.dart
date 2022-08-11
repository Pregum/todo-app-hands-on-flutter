import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/my_todo.dart';

/// boxを操作するクラスです。
class MyTodoBox {
  /// box名
  final _boxName = 'todos';

  /// シングルトン用オブジェクト
  static MyTodoBox? _ins;

  /// シングルトン用オブジェクト
  static MyTodoBox get instance => _ins ??= MyTodoBox._getInstance();

  /// インナーコンストラクタ
  MyTodoBox._internal();
  // ファクトリコンストラクタ
  factory MyTodoBox._getInstance() {
    return _ins ??= MyTodoBox._internal();
  }

  /// boxから全てのタスクを取得します。
  Future<Iterable<MyTodo>> getAll() async {
    final box = await _openBoxIfClosed();
    return box.values;
  }

  /// [value] をboxへ追加します。
  Future<int> add(MyTodo value) async {
    final box = await _openBoxIfClosed();
    final id = await box.add(value);
    return id;
  }

  /// [value] をboxから削除します。
  Future<void> delete(MyTodo value) async {
    final box = await _openBoxIfClosed();
    await box.delete(value.id);
  }

  /// [value] をboxにsetします。
  ///
  /// 既に存在する場合は上書きします。
  Future<MyTodo> set(MyTodo value) async {
    final box = await _openBoxIfClosed();
    await box.put(value.id, value);
    return value;
  }

  /// 全データを削除します。
  Future<int> clearAll() async {
    final box = await _openBoxIfClosed();
    final clearLength = await box.clear();
    return clearLength;
  }

  /// boxアクセス用オブジェクトを取得します。
  Future<Box<MyTodo>> _openBoxIfClosed() async {
    final isOpen = Hive.isBoxOpen(_boxName);
    final box = isOpen
        ? Hive.box<MyTodo>(_boxName)
        : await Hive.openBox<MyTodo>(_boxName);
    return box;
  }
}
