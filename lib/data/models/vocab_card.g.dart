// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VocabCardAdapter extends TypeAdapter<VocabCard> {
  @override
  final int typeId = 0;

  @override
  VocabCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VocabCard(
      id: fields[0] as String,
      targetText: fields[1] as String,
      english: fields[2] as String,
      exampleSentence: fields[3] as String?,
      audioUrl: fields[4] as String?,
      level: fields[5] as String,
      easeFactor: fields[6] as double,
      interval: fields[7] as int,
      repetitions: fields[8] as int,
      nextReview: fields[9] as DateTime?,
      addedAt: fields[10] as DateTime?,
      category: fields[11] as String?,
      isFavorite: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VocabCard obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.targetText)
      ..writeByte(2)
      ..write(obj.english)
      ..writeByte(3)
      ..write(obj.exampleSentence)
      ..writeByte(4)
      ..write(obj.audioUrl)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.easeFactor)
      ..writeByte(7)
      ..write(obj.interval)
      ..writeByte(8)
      ..write(obj.repetitions)
      ..writeByte(9)
      ..write(obj.nextReview)
      ..writeByte(10)
      ..write(obj.addedAt)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
