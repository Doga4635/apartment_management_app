import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String listId;
  String orderId;
  String productId;
  String name;
  int amount;
  double price;
  String details;
  String place;
  List<String> days;
  String flatId;
  String apartmentId;
  String floorNo;
  String flatNo;


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
   required this.flatId,
    required this.apartmentId,
    required this.floorNo,
    required this.flatNo,
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
      flatId: map['flatId'] ?? '',
      apartmentId: map['apartmentId'] ?? '',
      floorNo: map['floorNo'] ?? '',
      flatNo:  map['flatNo'] ?? '',
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
      "flatId": flatId,
      "apartmentId": apartmentId,
      "floorNo": floorNo,
      "flatNo": flatNo,

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
      flatId: snapshot['flatId'] ?? '',
      apartmentId: snapshot['apartmentId'] ?? '',
      floorNo: snapshot['floorNo'] ?? '',
      flatNo: snapshot['flatNo'] ?? '',
    );
  }

  static fromJson(Map<String, dynamic>? data) {}


}
