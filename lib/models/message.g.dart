// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 2;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] as String,
      userId: fields[1] as String,
      role: fields[2] as MessageRole,
      content: fields[3] as String,
      createdAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageRoleAdapter extends TypeAdapter<MessageRole> {
  @override
  final int typeId = 1;

  @override
  MessageRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageRole.user;
      case 1:
        return MessageRole.model;
      default:
        return MessageRole.user;
    }
  }

  @override
  void write(BinaryWriter writer, MessageRole obj) {
    switch (obj) {
      case MessageRole.user:
        writer.writeByte(0);
        break;
      case MessageRole.model:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
