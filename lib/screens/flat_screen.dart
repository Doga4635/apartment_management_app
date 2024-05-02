import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class FlatScreen extends StatefulWidget {
  final String flatId;


  const FlatScreen({Key? key, required this.flatId}) : super(key: key);

  @override
  _FlatScreenState createState() => _FlatScreenState();
}

class _FlatScreenState extends State<FlatScreen> {
  late List<Map<String, dynamic>> orders;

  @override
  void initState() {
    super.initState();
    orders = [];
    getOrdersForFlat(widget.flatId);
  }

  Future<void> getOrdersForFlat(String flatId) async {
    // Retrieve the flatId value from the flats collection
    final QuerySnapshot flatSnapshot = await FirebaseFirestore.instance.collection('flats').where('flatId', isEqualTo: flatId).get();
    if (flatSnapshot.docs.isNotEmpty) {
      final Map<String, dynamic> flat = flatSnapshot.docs.first.data() as Map<String, dynamic>;

      // Use the flatId value to update the flatId field in the orders collection
      await FirebaseFirestore.instance.collection('orders').where('flatId', isEqualTo: '').get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (flat != null) {
            FirebaseFirestore.instance.collection('orders').doc(doc.id).update({'flatId': flat['flatId']});
          }
        });
      });

      // Use the updated flatId value to filter the orders collection
      final List<Map<String, dynamic>> ordersList =
      await FirebaseFirestore.instance.collection('orders').where('flatId', isEqualTo: flatId).get().then((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
      setState(() {
        orders = ordersList;
      });
    } else {
      print('Flat not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders for Flat'),
        backgroundColor: Colors.teal,
      ),
      body: orders.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text(order['name']),
            subtitle: Text('${order['amount']} x ${order['price']}'),
          );
        },
      ),
    );
  }
}