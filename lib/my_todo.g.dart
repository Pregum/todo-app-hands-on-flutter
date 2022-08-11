// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<MyTodo> {
  @override
  final int typeId = 1;

  @override
  MyTodo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyTodo(
      id: fields[1] as String,
      taskName: fields[2] as String,
      isCompleted: fields[3] as bool,
      createdAt: fields[4] as DateTime?,
    )..updatedAt = fields[5] as DateTime;
  }

  @override
  void write(BinaryWriter writer, MyTodo obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.taskName)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
