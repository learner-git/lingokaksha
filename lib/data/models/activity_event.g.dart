// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityEventAdapter extends TypeAdapter<ActivityEvent> {
  @override
  final int typeId = 1;

  @override
  ActivityEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityEvent(
      id: fields[0] as String,
      type: fields[1] as String,
      description: fields[2] as String,
      xpEarned: fields[3] as int,
      timestamp: fields[4] as DateTime,
      metadata: (fields[5] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ActivityEvent obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.xpEarned)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
