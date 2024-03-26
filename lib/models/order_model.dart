import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String listId;
  String orderId;
  String productId;
  String name;
  int amount;
  String details;
  String place;

  OrderModel({
    required this.listId,
    required this.orderId,
    required this.productId,
    required this.name,
    required this.amount,
    required this.details,
    required this.place,
  });

  factory OrderModel.fromMap(Map<String,dynamic> map) {
    return OrderModel(
      listId: map['listId'] ?? '',
      orderId: map['orderId'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      amount: map['amount'] ?? '',
      details: map['details'] ?? '',
      place: map['place'] ?? '',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "listId": listId,
      "orderId": orderId,
      "productId": productId,
      "name": name,
      "amount": amount,
      "details": details,
      "place": place,
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    return OrderModel(
      listId: snapshot['listId'] ?? '',
      orderId: snapshot['orderId'] ?? '',
      productId: snapshot['productId'] ?? '',
      name: snapshot['name'] ?? '',
      amount: snapshot['amount'] ?? '',
      details: snapshot['details'] ?? '',
      place: snapshot['place'] ?? '',
    );
  }

}