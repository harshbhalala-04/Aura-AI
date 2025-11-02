import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
enum MessageRole {
  @HiveField(0)
  user,
  @HiveField(1)
  model,
}

@HiveType(typeId: 2)
class Message extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  MessageRole role;

  @HiveField(3)
  String content;

  @HiveField(4)
  DateTime? createdAt;

  Message({
    required this.id,
    required this.userId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      userId: json['user_id'],
      role: json['role'] == 'user' ? MessageRole.user : MessageRole.model,
      content: json['content'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'role': role == MessageRole.user ? 'user' : 'model',
      'content': content,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Message copyWith({
    String? id,
    String? userId,
    MessageRole? role,
    String? content,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
