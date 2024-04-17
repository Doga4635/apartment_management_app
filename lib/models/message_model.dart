import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String uid;
  final String content;
  final Timestamp createdAt;
  final String role;
  final String messageId;

  MessageModel({
    required this.uid,
    required this.content,
    required this.createdAt,
    required this.role,
    required this.messageId,
  });

  factory MessageModel.fromMap(Map<String,dynamic> map) {
    return MessageModel(
      uid: map['uid'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      role: map['role'] ?? '',
      messageId: map['messageId'] ?? '',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "uid": uid,
      "content": content,
      "createdAt": createdAt,
      "role": role,
      "messageId": messageId,
    };
  }

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MessageModel(
      uid: snapshot['uid'] ?? '',
      content: snapshot['content'] ?? '',
      createdAt: snapshot['createdAt'] ?? '0',
      role: snapshot['role'] ?? '',
      messageId: snapshot['messageId'] ?? '',
    );
  }

}