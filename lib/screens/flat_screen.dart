import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../utils/utils.dart';
import 'ana_menü_yardım_screen.dart';

class FlatScreen extends StatefulWidget {

  final String apartmentId;
  final String floorNo;
  final String flatNo;


  const FlatScreen({Key? key,  required this.apartmentId, required this.floorNo, required this.flatNo }) : super(key: key);

  @override
  FlatScreenState createState() => FlatScreenState();
}

class FlatScreenState extends State<FlatScreen> {
  List<OrderModel> orders = []; // Define orders property
  late String _currentDay;
  bool _isLoading = true;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _updateCurrentDay();
    fetchOrders(widget.apartmentId, widget.floorNo, widget.flatNo);
  }

  void _updateCurrentDay() {
    final now = DateTime.now();
    // Convert the current date to a string representation of the day (e.g., Monday, Tuesday, etc.)
    _currentDay = getDayOfWeek(now.weekday);
  }

  Future<void> fetchOrders(String apartmentId, String floorNo,
      String flatNo) async {
    orders.clear();
    try {
      // Fetch orders for a specific apartment, floor, and flat
      final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('apartmentId', isEqualTo: apartmentId)
          .where('floorNo', isEqualTo: floorNo)
          .where('flatNo', isEqualTo: flatNo)
          .where('days', arrayContains: _currentDay)
          .get();

      if (orderSnapshot.docs.isNotEmpty) {
        orders = orderSnapshot.docs.map((doc) {
          return OrderModel(
              listId: doc['listId'] ?? '',
              orderId: doc['orderId'] ?? '',
              productId: doc['productId'] ?? '',
              name: doc['name'] ?? '',
              amount: doc['amount'] ?? '',
              price: doc['price'] ?? '',
              details: doc['details'] ?? '',
              place: doc['place'] ?? '',
              days: List<String>.from(doc['days']),
              flatId: doc['flatId'] ?? '',
              apartmentId: apartmentId,
              floorNo: floorNo,
              flatNo: flatNo);
        }).toList();
      } else {
        print('No documents found for the current user.');
      }

      for (var order in orders) {
        totalPrice += (order.amount) * (order.price);
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daire ${widget.flatNo} Siparişleri'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading == true ? const Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      ) : orders.isEmpty
          ? const Center(
        child: Text(
          'Bu dairenin hiç siparişi bulunmamaktadır.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
          Expanded(
            child: ListView(
              children: orders.map((order) {
                return ListTile(
                  title: Text('${order.amount} Adet',
                      style: const TextStyle(fontSize: 14)),
                  leading: Text(
                      order.name, style: const TextStyle(fontSize: 16)),
                  subtitle: Text('${order.price} TL'),
                  trailing: Text('${order.price * order.amount}',
                      style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
            ),
          ),
                  ],
                ),
      bottomNavigationBar: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16.0,bottom: 20.0,right: 150.0,top: 16.0),
            color: Colors.white,
            child: Text(
              'Toplam: $totalPrice TL',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton(
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const YardimScreen()),
              );},
              tooltip: 'Yardım',
              backgroundColor: Colors.teal,
              child: const Icon(Icons.question_mark,
                color: Colors.white,
              ),
            ),
          ),
        ],

      ),
    );
  }
}
