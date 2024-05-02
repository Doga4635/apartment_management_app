import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String id;
  String name;
  String apartmentId;
  String description;
  String price;
  Map<String, bool> flatId;

  PaymentModel({
    required this.id,
    required this.name,
    required this.apartmentId,
    required this.description,
    required this.price,
    required this.flatId,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      apartmentId: map['apartmentId'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      flatId: (map['flatId'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as bool)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "apartmentId": apartmentId,
      "description": description,
      "price": price,
      "flatId": flatId.map((key, value) => MapEntry(key, value as bool)),
    };
  }

  factory PaymentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PaymentModel(
      id: snapshot['id'] ?? '',
      name: snapshot['name'] ?? '',
      apartmentId: snapshot['apartmentId'] ?? '',
      description: snapshot['description'] ?? '',
      price: snapshot['price'] ?? '',
      flatId: (snapshot['flatId'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as bool)),
    );
  }
}