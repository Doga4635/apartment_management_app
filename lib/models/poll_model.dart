import 'package:cloud_firestore/cloud_firestore.dart';

class PollModel {
  String id;
  String apartmentId;
  String title;
  List<String> options;
  Map<String, int> scores;
  Timestamp createdAt;
  Timestamp finishedAt;

  PollModel({
    required this.id,
    required this.apartmentId,
    required this.title,
    required this.options,
    required this.scores,
    required this.createdAt,
    required this.finishedAt,
  });

  factory PollModel.fromMap(Map<String, dynamic> map) {
    return PollModel(
      id: map['id'],
      apartmentId: map['apartmentId'],
      title: map['title'],
      options: List<String>.from(map['options']),
      scores: Map<String, int>.from(map['scores']),
      createdAt: map['createdAt'],
      finishedAt: map['finishedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apartmentId': apartmentId,
      'title': title,
      'options': options,
      'scores': scores,
      'createdAt': createdAt,
      'finishedAt': finishedAt,
    };
  }
}
