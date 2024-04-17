import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class AlimScreen extends StatefulWidget {
  const AlimScreen({Key? key}) : super(key: key);

  @override
  AlimScreenState createState() => AlimScreenState();

}

class AlimScreenState extends State<AlimScreen> {
  late String _currentDay;

  @override
  void initState() {
    super.initState();
    _updateCurrentDay();
  }
  // Function to update the current day
  void _updateCurrentDay() {
    final now = DateTime.now();
    // Convert the current date to a string representation of the day (e.g., Monday, Tuesday, etc.)
    _currentDay = getDayOfWeek(now.weekday);
  }

  Future<int> getTotalOrdersAmount(String location) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('place', isEqualTo: location)
        .get();

    int totalAmount = 0;
    querySnapshot.docs.forEach((doc) {
      int itemAmount = doc['amount'];
      totalAmount += itemAmount;
    });
    return totalAmount;
  }

  void showMarketQuantity(String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Market Orders'),
          content: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('orders')
                .where('place', isEqualTo: location)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, int> productsMap = {};
                snapshot.data?.docs.forEach((doc) {
                  String productName = doc['name'];
                  int productAmount = doc['amount'];
                  if (productsMap.containsKey(productName)) {
                    productsMap[productName] = productsMap[productName]! + productAmount;
                  } else {
                    productsMap[productName] = productAmount;
                  }
                });
                List<Widget> productsList = [];
                productsMap.forEach((productName, productAmount) {
                  productsList.add(
                    Text('$productName: $productAmount'),
                  );
                });
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: productsList,
                );
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
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
            _buildLocationButton('Market'),
            const SizedBox(height: 20.0),
            _buildLocationButton('Fırın'),
            const SizedBox(height: 20.0),
            _buildLocationButton('Manav'),
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

  Widget _buildLocationButton(String location) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          showMarketQuantity(location);
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