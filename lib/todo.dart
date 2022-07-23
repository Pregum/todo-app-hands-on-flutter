import 'package:hive/hive.dart';

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

  /// ctor
  Todo(
      {required this.id,
      required this.taskName,
      required this.isCompleted,
      required this.isEditEnabled});
}
