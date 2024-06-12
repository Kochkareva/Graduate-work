// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_token_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JwtTokenModelAdapter extends TypeAdapter<JwtTokenModel> {
  @override
  final int typeId = 0;

  @override
  JwtTokenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JwtTokenModel(
      refresh: fields[0] as String,
      access: fields[1] as String,
      username: fields[2] as String,
      dateOfBirth: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JwtTokenModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.refresh)
      ..writeByte(1)
      ..write(obj.access)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.dateOfBirth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JwtTokenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
