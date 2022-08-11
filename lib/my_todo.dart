import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'my_todo.g.dart';

@HiveType(typeId: 1)

/// todo
class MyTodo {
  /// id
  @HiveField(1)
  String id;

  /// タスクの名前
  @HiveField(2)
  String taskName;

  /// タスクの完了フラグ
  /// 完了なら[true], 未完了なら [false] が入ります。
  @HiveField(3)
  bool isCompleted;

  /// 作成日時
  @HiveField(4)
  DateTime createdAt;

  /// 更新日時
  @HiveField(5)
  DateTime updatedAt;

  /// ctor
  MyTodo({
    required this.id,
    required this.taskName,
    required this.isCompleted,
    DateTime? createdAt,
    DateTime? udatedAt,
  })  : createdAt = createdAt ?? DateTime(2000),
        updatedAt = udatedAt ?? DateTime(2000);

  @override
  String toString() {
    return id;
  }
}

/// [MyTodo] クラスの拡張メソッド
extension TodoEx on MyTodo {
  /// 更新日を `[yyyy-MM-dd HH:mm]` フォーマットで取得します。
  ///
  /// e.g.) 2022-08-11 14:17
  String get prettyUpdateAt {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(updatedAt);
  }
}
