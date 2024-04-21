import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String id;
  String name;
  String description;
  String price;
  Map<String, bool> flats;

  PaymentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.flats,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      flats: (map['flats'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as bool)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "flats": flats.map((key, value) => MapEntry(key, value as bool)),
    };
  }

  factory PaymentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PaymentModel(
      id: snapshot['id'] ?? '',
      name: snapshot['name'] ?? '',
      description: snapshot['description'] ?? '',
      price: snapshot['price'] ?? '',
      flats: (snapshot['flats'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as bool)),
    );
  }
}