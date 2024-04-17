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

  void showMarketQuantity(String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Market Orders'),
            content: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('orders')
                  .where('place', isEqualTo: location)
                  .where('days', arrayContains: _currentDay)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, Map<String, int>> productsDetailsMap = {};
                  Map<String, int> productsMap = {};
                  snapshot.data?.docs.forEach((doc) {
                    String productName = doc['name'];
                    String details = doc['details'];
                    int productAmount = doc['amount'];

                    // If the product already exists in the map, update its details and amount
                    if (productsDetailsMap.containsKey(productName)) {
                      productsMap[productName] = productsMap[productName]! + productAmount;
                      if (productsDetailsMap[productName]!.containsKey(details)) {
                        productsDetailsMap[productName]![details] =
                            productsDetailsMap[productName]![details]! + productAmount;
                      } else {
                        productsDetailsMap[productName]![details] = productAmount;
                      }
                    } else {
                      productsMap[productName] = productAmount;
                      productsDetailsMap[productName] = {details: productAmount};
                    }
                  });

                  List<Widget> productsList = [];

                  productsDetailsMap.forEach((productName, detailsMap) {
                    List<Widget> detailsList = [];

                    detailsMap.forEach((details, amount) {
                      detailsList.add(
                        Text('$details: $amount'),
                      );
                    });

                    productsList.add(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('> $productName: ${productsMap[productName]}'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: detailsList,
                          ),
                        ],
                      ),
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
          ),
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