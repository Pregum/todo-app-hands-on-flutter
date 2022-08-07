import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/todo.dart';

/// boxを操作するクラスです。
class TodoBox {
  /// box名
  final _boxName = 'todos';

  /// シングルトン用オブジェクト
  static TodoBox? _ins;

  /// シングルトン用オブジェクト
  static TodoBox get instance => _ins ??= TodoBox._getInstance();

  /// インナーコンストラクタ
  TodoBox._internal();
  // ファクトリコンストラクタ
  factory TodoBox._getInstance() {
    return _ins ??= TodoBox._internal();
  }

  /// boxから全てのタスクを取得します。
  Future<Iterable<Todo>> getAll() async {
    final box = await _openBoxIfClosed();
    return box.values;
  }

  /// [value] をboxへ追加します。
  Future<int> add(Todo value) async {
    final box = await _openBoxIfClosed();
    final id = await box.add(value);
    return id;
  }

  /// [value] をboxから削除します。
  Future<void> delete(Todo value) async {
    final box = await _openBoxIfClosed();
    await box.delete(value.id);
  }

  /// [value] をboxにsetします。
  ///
  /// 既に存在する場合は上書きします。
  Future<Todo> set(Todo value) async {
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
  Future<Box<Todo>> _openBoxIfClosed() async {
    final isOpen = Hive.isBoxOpen(_boxName);
    final box =
        isOpen ? Hive.box<Todo>(_boxName) : await Hive.openBox<Todo>(_boxName);
    return box;
  }
}
