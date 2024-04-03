import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {
  String uid;
  String listId;
  String name;
  List<String> days;

  ListModel({
    required this.uid,
    required this.listId,
    required this.name,
    required this.days,
  });

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      uid: map['uid'] ?? '',
      listId: map['listId'] ?? '',
      name: map['name'] ?? '',
      days: List<String>.from(map['days'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "listId": listId,
      "name": name,
      "days": days,
    };
  }

  factory ListModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ListModel(
      uid: snapshot['uid'] ?? '',
      listId: snapshot['listId'] ?? '',
      name: snapshot['name'] ?? '',
      days: List<String>.from(snapshot['days'] ?? []),
    );
  }
}
