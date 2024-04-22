import 'package:cloud_firestore/cloud_firestore.dart';

class ApartmentModel {
  String id;
  String name;
  int floorCount;
  int flatCount;
  int managerCount;
  int doormanCount;

  ApartmentModel({
    required this.id,
    required this.name,
    required this.floorCount,
    required this.flatCount,
    required this.managerCount,
    required this.doormanCount,
  });

  factory ApartmentModel.fromMap(Map<String,dynamic> map) {
    return ApartmentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      floorCount: map['floorCount'] ?? '0',
      flatCount: map['flatCount'] ?? '0',
      managerCount: map['managerCount'] ?? '0',
      doormanCount: map['doormanCount'] ?? '0',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "floorCount": floorCount,
      "flatCount": flatCount,
      "managerCount": managerCount,
      "doormanCount": doormanCount,
    };
  }

  factory ApartmentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ApartmentModel(
      id: snapshot['id'] ?? '',
      name: snapshot['name'] ?? '',
      floorCount: snapshot['floorCount'] ?? '',
      flatCount: snapshot['flatCount'] ?? 0,
      managerCount: snapshot['managerCount'] ?? '',
      doormanCount: snapshot['doormanCount'] ?? '',
    );
  }

}