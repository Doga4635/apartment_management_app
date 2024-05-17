import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PaymentModel {
  String id;
  String name;
  String apartmentId;
  String description;
  String price;
  String flatNo;
  bool paid = false;
  Timestamp dueDate;

  PaymentModel({
    required this.id,
    required this.name,
    required this.apartmentId,
    required this.description,
    required this.price,
    required this.flatNo,
    required this.paid,
    required this.dueDate,
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
      dueDate: map['dueDate'] ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "apartmentId": apartmentId,
      "description": description,
      "price": price,
      "flatNo": flatNo,
      "paid": paid,
      "dueDate": dueDate,
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
      dueDate: snapshot['dueDate'] ?? '',
    );
  }

  String getFormattedDueDate() {
    DateTime dateTime = dueDate.toDate();
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

}
