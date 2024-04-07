import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String uid;
  final String content;
  final DateTime createdAt;
  final String role;

  MessageModel({
    required this.uid,
    required this.content,
    required this.createdAt,
    required this.role,
  });

  factory MessageModel.fromMap(Map<String,dynamic> map) {
    return MessageModel(
      uid: map['uid'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] ?? '0',
      role: map['role'] ?? '',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "uid": uid,
      "content": content,
      "createdAt": createdAt,
      "role": role,
     
    };
  }

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MessageModel(
      uid: snapshot['uid'] ?? '',
      content: snapshot['content'] ?? '',
      createdAt: snapshot['createdAt'] ?? '0',
      role: snapshot['role'] ?? '',
    );
  }

}