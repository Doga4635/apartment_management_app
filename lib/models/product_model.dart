import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String productId;
  String name;

  ProductModel({
    required this.productId,
    required this.name,
  });

  factory ProductModel.fromMap(Map<String,dynamic> map) {
    return ProductModel(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "productId": productId,
      "name": name,
    };
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ProductModel(
      productId: snapshot['productId'] ?? '',
      name: snapshot['name'] ?? '',
    );
  }

}