import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String id;
  String name;
  String apartmentId;
  String description;
  String price;
  String flatNo;
  bool paid = false;

  PaymentModel({
    required this.id,
    required this.name,
    required this.apartmentId,
    required this.description,
    required this.price,
    required this.flatNo,
    required this.paid,
  });

  factory PaymentModel.fromMap(String id, Map<String, dynamic> map) {
    return PaymentModel(
      id: id,
      name: map['name'] ?? '',
      apartmentId: map['apartmentId'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      flatNo: map['flatNo'] ?? '',
      paid: map['paid'] ?? false,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "apartmentId": apartmentId,
      "description": description,
      "price": price,
      "flatNo": flatNo,
      "paid": paid,
    };
  }

  factory PaymentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PaymentModel(
      id: snapshot.id,
      name: snapshot['name'] ?? '',
      apartmentId: snapshot['apartmentId'] ?? '',
      description: snapshot['description'] ?? '',
      price: snapshot['price'] ?? '',
      flatNo: snapshot['flatNo'] ?? '',
      paid: snapshot['paid'] ?? false,

    );
  }

  /*// Added a new property to store the flatIdPayments as a comma separated string
  String get flatIdsString => flatNo.keys.join(',');

  // Added a new method to set the flatIdPayments from a comma separated string
  set flatIdsString(String value) {
    flatNo = {};
    List<String> ids = value.split(',').map((e) => e.trim()).toList();
    ids.forEach((id) => flatNo[id] = false);
    }*/
}
