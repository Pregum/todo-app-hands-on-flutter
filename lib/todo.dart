import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)

/// todo
class Todo {
  /// id
  @HiveField(1)
  String id;

  /// タスクの名前
  @HiveField(2)
  String taskName;

  /// タスクの完了フラグ
  @HiveField(3)
  bool isCompleted;

  /// タスクの編集中フラグ
  @HiveField(4)
  bool isEditEnabled;

  /// 作成日時
  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  /// ctor
  Todo(
      {required this.id,
      required this.taskName,
      required this.isCompleted,
      required this.isEditEnabled,
      DateTime? createdAt,
      DateTime? udatedAt})
      : createdAt = createdAt ?? DateTime(2000),
        updatedAt = createdAt ?? DateTime(2000);

  @override
  String toString() {
    return id;
  }
}

extension TodoEx on Todo {
  String get prettyUpdateAt {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(updatedAt);
  }
}
