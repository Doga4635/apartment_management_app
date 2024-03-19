import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {

  String uid;
  String listId;
  String name;

  ListModel({
    required this.uid,
    required this.listId,
    required this.name,
  });

  factory ListModel.fromMap(Map<String,dynamic> map) {
    return ListModel(
      uid: map['uid'] ?? '',
      listId: map['listId'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "uid": uid,
      "listId": listId,
      "name": name,
    };
  }

  factory ListModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ListModel(
      uid: snapshot['uid'] ?? '',
      listId: snapshot['listId'] ?? '',
      name: snapshot['name'] ?? '',
    );
  }

}