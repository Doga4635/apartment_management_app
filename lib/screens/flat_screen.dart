import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_management_app/models/flat_model.dart';


class FlatScreen extends StatefulWidget {
  final List<FlatModel> flats;


  const FlatScreen({Key? key, required this.flats}) : super(key: key);


  @override
  _FlatScreenState createState() => _FlatScreenState();
}


class _FlatScreenState extends State<FlatScreen> {
  late Map<String, List<Map<String, dynamic>>> ordersByFlat = {};


  @override
  void initState() {
    super.initState();
    // fetchOrders();
  }


/* Future<void> fetchOrders() async {
   try {
     for (final flat in widget.flats) {
       final apartmentId = flat.apartmentId;
       final flatNo = flat.flatNo;


       final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
           .collection('orders')
           .where('apartmentId', isEqualTo: apartmentId)
           .where('flatNo', isEqualTo: flatNo)
           .get();


       final flatOrders = orderSnapshot.docs.map((orderDoc) {
         final orderData = orderDoc.data()!;
         return {
          // 'name': orderData['name'],
         //  'amount': orderData['amount'],
          // 'price': orderData['price'],
         };
       }).toList();


       final key = '$apartmentId-$flatNo';
       if (!ordersByFlat.containsKey(key)) {
         ordersByFlat[key] = [];
       }
       ordersByFlat[key]!.addAll(flatOrders);
    }


     setState(() {});
   } catch (error) {
     print('Error fetching orders: $error');
     // Handle error gracefully, e.g., show error message to the user
   }
 }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders by Flat'),
        backgroundColor: Colors.teal,
      ),
      body: ordersByFlat.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        children: ordersByFlat.entries.map((entry) {
          final key = entry.key;
          final flatOrders = entry.value;
          final apartmentId = key.split('-')[0];
          final flatNo = key.split('-')[1];


          return Card(
            child: ListTile(
              title: Text('Apartment: $apartmentId, Flat: $flatNo'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: flatOrders.map<Widget>((order) {
                  return Text(
                      '${order['name']}: ${order['amount']} x ${order['price']}');
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
