import 'package:apartment_management_app/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {
  String uid;
  String listId;
  String flatId;
  String name;
  List<String> days;
  List<OrderModel> orders;

  ListModel({
    required this.uid,
    required this.listId,
    required this.flatId,
    required this.name,
    required this.days,
    required this.orders,
  });

  factory ListModel.fromSnapshot(DocumentSnapshot snapshot) {

      // Convert list of order snapshots to a list of OrderModel objects
      List<OrderModel> orders = (snapshot['orders'] as List<dynamic>)
          .map((orderSnapshot) => OrderModel.fromSnapshot(orderSnapshot))
          .toList();

        return ListModel(
            listId: snapshot.id,
             name: snapshot['name'],
             flatId: snapshot['flatId'],
              uid: snapshot['uid'],
              days: List<String>.from(snapshot.get('days') ?? []).map((e) => e.toString()).toList(),
              orders: orders,
       );
      }



  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "listId": listId,
      "flatId": flatId,
      "name": name,
      "days": days,
      "orders": orders.map((order) => order.toMap()).toList(),
    };
  }


}
