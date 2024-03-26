import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:apartment_management_app/screens/new_order_screen.dart';
import '../models/order_model.dart';

class AlimScreen extends StatefulWidget {
  const AlimScreen({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _fetchMarketProducts();// Fetch initial data
    _fetchFirinProducts();
    _fetchManavProducts();
  }
  Future<void> _fetchMarketProducts() async {
    // Implement fetching Market products from Firebase Firestore
    // For example:
     QuerySnapshot marketSnapshot =
         await FirebaseFirestore.instance.collection('market_products').get();
    // Parse the data and update the marketProducts list
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
      );
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışveriş Listesi'),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewOrderScreen(),
            ),
          );
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

