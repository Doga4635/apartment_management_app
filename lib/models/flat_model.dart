
import 'package:cloud_firestore/cloud_firestore.dart';

class FlatModel {
  String uid;
  String flatId;
  String apartmentId;
  String floorNo;
  String flatNo;
  String role;
  bool garbage;

  FlatModel({
    required this.uid,
    required this.flatId,
    required this.apartmentId,
    required this.floorNo,
    required this.flatNo,
    required this.role,
    required this.garbage,
  });

  factory FlatModel.fromMap(Map<String,dynamic> map) {
    return FlatModel(
      uid: map['uid'] ?? '',
      flatId: map['flatId'] ?? '',
      apartmentId: map['apartmentId'] ?? '0',
      floorNo: map['floorNo'] ?? '',
      flatNo: map['flatNo'] ?? '',
      role: map['role'] ?? '',
      garbage: map['garbage'] ?? '',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "uid": uid,
      "flatId": flatId,
      "apartmentId": apartmentId,
      "floorNo": floorNo,
      "flatNo": flatNo,
      "role": role,
      "garbage": garbage,
    };
  }

  factory FlatModel.fromSnapshot(DocumentSnapshot snapshot) {
    return FlatModel(
      uid: snapshot['uid'] ?? '',
      flatId: snapshot['flatId'] ?? '',
      apartmentId: snapshot['apartmentId'] ?? '',
      floorNo: snapshot['floorNo'] ?? 0,
      flatNo: snapshot['flatNo'] ?? '',
      role: snapshot['role'] ?? '',
      garbage: snapshot['garbage'] ?? false,
    );
  }

}