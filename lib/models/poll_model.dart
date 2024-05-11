// poll_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PollModel {
  String id;
  String apartmentId;
  String title;
  List<String> options;
  Timestamp createdAt;
  Timestamp updatedAt;

  PollModel(
      {required this.id,
        required this.apartmentId,
        required this.title,
        required this.options,
        required this.createdAt,
        required this.updatedAt});

  factory PollModel.fromMap(Map<String, dynamic> map) {
    return PollModel(
      id: map['id'],
      apartmentId: map['apartmentId'],
      title: map['title'],
      options: List<String>.from(map['options']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apartmentId': apartmentId,
      'title': title,
      'options': options,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
