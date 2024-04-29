import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String listId;
  String orderId;
  String productId;
  String name;
  int amount;
  int price;
  String details;
  String place;
  List<String> days;

  OrderModel({
    required this.listId,
    required this.orderId,
    required this.productId,
    required this.name,
    required this.amount,
    required this.price,
    required this.details,
    required this.place,
    required this.days,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      listId: map['listId'] ?? '',
      orderId: map['orderId'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      amount: map['amount'] ?? 0,
      price: map['price'] ?? 0,
      details: map['details'] ?? '',
      place: map['place'] ?? '',
      days: (map['days'] as List<dynamic>).cast<String>(),
    );
  }



  Map<String, dynamic> toMap() {
    return {
      "listId": listId,
      "orderId": orderId,
      "productId": productId,
      "name": name,
      "amount": amount,
      "price": price,
      "details": details,
      "place": place,
      "days": days,
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    return OrderModel(
      listId: snapshot['listId'] ?? '',
      orderId: snapshot['orderId'] ?? '',
      productId: snapshot['productId'] ?? '',
      name: snapshot['name'] ?? '',
      amount: snapshot['amount'] ?? 0,
      price: snapshot['price'] ?? 0,
      details: snapshot['details'] ?? '',
      place: snapshot['place'] ?? '',
      days: (snapshot['days'] as List<dynamic>).cast<String>(),
    );
  }

  static fromJson(Map<String, dynamic>? data) {}
}
