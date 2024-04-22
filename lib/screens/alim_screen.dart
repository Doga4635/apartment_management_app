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
            title: const Text('Market Orders'),
            content: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('orders')
                  .where('place', isEqualTo: location)
                  .where('days', arrayContains: _currentDay)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, Map<String, int>> productsDetailsMap = {};
                  Map<String, int> productsMap = {};
                  snapshot.data?.docs.forEach((doc) {
                    String productName = doc['name'];
                    String details = doc['details'];
                    int productAmount = doc['amount'];
                    //int price = doc['price'];

                    // For showing non-detailed orders
                    if(details == "") {
                      details = "Normal";
                    }

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
                      TextEditingController priceController = TextEditingController(); // Add controller for each TextField
                      detailsList.add(
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8.0,right: 16.0,bottom: 8.0),
                              child: Text('$details: $amount'),
                            ),
                            SizedBox(
                              width: 40, // Adjust width according to your preference
                              height: 15,
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  hintStyle: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            const Text(' TL '),
                            TextButton(onPressed: () {} , child: const Icon(Icons.check,color: Colors.teal,),)
                          ],
                        ),
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
                child: const Text('Close',style: TextStyle(color: Colors.teal),),
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