import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:apartment_management_app/screens/new_order_screen.dart';
import '../models/order_model.dart';
import '../utils/utils.dart';

class AlimScreen extends StatefulWidget {
  List<OrderModel> marketProducts = []; // Products for the market
  List<OrderModel> firinProducts = []; // Products for the fırın
  List<OrderModel> manavProducts = []; // Products for the manav


   AlimScreen({
    super.key,
    required this.marketProducts,
    required this.firinProducts,
    required this.manavProducts,
  });

  @override
  _AlimScreenState createState() => _AlimScreenState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _AlimScreenState extends State<AlimScreen> {
  List<OrderModel> marketProducts = []; // Products for the market
  List<OrderModel> firinProducts = []; // Products for the fırın
  List<OrderModel> manavProducts = []; // Products for the manav
  late String _currentDay;


  @override
  void initState() {
    super.initState();
    _fetchMarketProducts(); // Fetch initial data
    _fetchFirinProducts();
    _fetchManavProducts();
    _updateCurrentDay();
  }

  // Function to update the current day
  void _updateCurrentDay() {
    final now = DateTime.now();
    // Convert the current date to a string representation of the day (e.g., Monday, Tuesday, etc.)
    _currentDay = getDayOfWeek(now.weekday);
  }

  Future<void> _fetchMarketProducts() async {
    // Implement fetching Market products from Firebase Firestore
    // For example:
    QuerySnapshot marketSnapshot =
    await FirebaseFirestore.instance.collection('orders')
        .where('days',arrayContains: [_currentDay])
        .where('place',isEqualTo: 'Market')
        .get();
    marketProducts = _parseProducts(marketSnapshot);
    // Parse the data and update the marketProducts list
    setState(() {});
  }

  Future<void> _fetchFirinProducts() async {
    // Implement fetching Fırın products from Firebase Firestore
    // For example:
    QuerySnapshot firinSnapshot =
    await FirebaseFirestore.instance.collection('firin_products').get();
    // Parse the data and update the firinProducts list
  }

  Future<void> _fetchManavProducts() async {
    QuerySnapshot manavSnapshot =
    await FirebaseFirestore.instance.collection('manav_products').get();
    manavProducts = _parseProducts(manavSnapshot);
    setState(() {}); // Update the UI
  }

  List<OrderModel> _parseProducts(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return OrderModel(
        orderId: doc['orderId'] ?? '',
        productId: doc['productId'] ?? '',
        name: doc['name'] ?? '',
        amount: doc['amount'] ?? 0,
        details: doc['details'] ?? '',
        listId: '',
        place: doc['place'] ?? '',
        days: doc['days'] ?? '',
      );
    }).toList();
  }

  int calculateTotalQuantity(List<OrderModel> products) {
    int totalQuantity = 0;
    for (var product in products) {
      totalQuantity += product.amount;
    }
    return totalQuantity;
  }

  void showTotalQuantityDialog(String location, List<OrderModel> products) {
    int totalQuantity = calculateTotalQuantity(products);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(location),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Quantity: $totalQuantity'), // Print total quantity for the location
              SizedBox(height: 10), // Add some spacing
              ...products.map((product) {
                return ListTile(
                  title: Text('${product.name}: ${product.amount}'),
                );
              }).toList(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışveriş Listesi'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLocationButton('Market', marketProducts),
            const SizedBox(height: 20.0),
            _buildLocationButton('Fırın', firinProducts),
            const SizedBox(height: 20.0),
            _buildLocationButton('Manav', manavProducts),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Dağıtım button tap
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  'Diğer',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton(String location, List<OrderModel> products) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          showTotalQuantityDialog(location, products);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
        ),
        child: Text(
          location,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}