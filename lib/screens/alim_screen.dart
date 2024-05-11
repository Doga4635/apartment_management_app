import 'package:apartment_management_app/screens/permission_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'multiple_flat_user_profile_screen.dart';

class AlimScreen extends StatefulWidget {
  const AlimScreen({Key? key}) : super(key: key);

  @override
  AlimScreenState createState() => AlimScreenState();

}

class AlimScreenState extends State<AlimScreen> {
  late String _currentDay;
  String? price;
  String? apartmentId;

  @override
  void initState() {
    super.initState();
    _updateCurrentDay();
  }
  // Function to update the current day
  void _updateCurrentDay() async {
    final now = DateTime.now();
    // Convert the current date to a string representation of the day (e.g., Monday, Tuesday, etc.)
    _currentDay = getDayOfWeek(now.weekday);
    apartmentId = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);
  }

  void showMarketQuantity(String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('$location Siparişleri'),
            content: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('orders')
                  .where('place', isEqualTo: location)
                  .where('days', arrayContains: _currentDay)
                  .where('apartmentId', isEqualTo: apartmentId)
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
                      TextEditingController priceController = TextEditingController();
                      detailsList.add(
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8.0,right: 16.0,bottom: 8.0),
                              child: Text('$details: $amount',style: const TextStyle(fontSize: 14),),
                            ),
                            SizedBox(
                              width: 40, // Adjust width according to your preference
                              height: 15,
                              child: FutureBuilder(
                                future: getProductPrice(productName),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    print('Error: ${snapshot.error}');
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    priceController = TextEditingController(text: snapshot.data);
                                    return TextField(
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(fontSize: 14),
                                    );
                                  }
                                },
                              ),
                            ),
                            const Text(' TL '),
                            TextButton(onPressed: () async {
                                String newPrice = priceController.text;
                                  List<String> orderId = await getOrderIds(productName,details);
                                  for(String id in orderId) {
                                    FirebaseFirestore.instance.collection('orders').doc(id).update({
                                      'price': double.parse(newPrice),
                                    });
                                  }
                                  updateProductPrice(productName, newPrice);
                            } , child: const Icon(Icons.check,color: Colors.teal,),)
                          ],
                        ),
                      );
                    });

                    productsList.add(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('> $productName: ${productsMap[productName]}',style: const TextStyle(fontSize: 16),),
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
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışveriş Listesi'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [

          FutureBuilder(
              future: getRoleForFlat(ap.userModel.uid), // Assuming 'role' is the field that contains the user's role
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: Colors.teal,
                  ));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String userRole = snapshot.data ?? '';
                  return userRole == 'Apartman Yöneticisi' ? IconButton(
                    onPressed: () async {
                      String? apartmentName = await getApartmentIdForUser(ap.userModel.uid);

                      //Checking if the user has more than 1 role
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('flats')
                          .where('apartmentId', isEqualTo: apartmentName)
                          .where('isAllowed', isEqualTo: false)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const PermissionScreen()),
                        );
                      } else {
                        showSnackBar(
                            'Kayıt olmak için izin isteyen kullanıcı bulunmamaktadır.');
                      }
                    },
                    icon: const Icon(Icons.verified_user),
                  ) : const SizedBox(width: 2,height: 2);
                }
              }
          ),
          IconButton(
            onPressed: () async {
              String currentUserUid = ap.userModel.uid;

              //Checking if the user has more than 1 role
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('flats')
                  .where('uid', isEqualTo: currentUserUid)
                  .get();

              if (querySnapshot.docs.length > 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MultipleFlatUserProfileScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),

                );
              }
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              ap.userSignOut().then((value) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              ));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
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

  Future<List<String>> getOrderIds(String productName, String details) async {
    List<String> orderIds = [];
    if(details == 'Normal') {
      details = '';
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('name', isEqualTo: productName)
        .where('details', isEqualTo: details)
        .get();

    for (var doc in querySnapshot.docs) {
      orderIds.add(doc.id);
    }

    return orderIds;
  }

  Future<void> updateProductPrice(String productName, String price) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: productName)
        .get();

    for (var doc in querySnapshot.docs) {
      FirebaseFirestore.instance.collection('products').doc(doc.id).update({
        'price': double.parse(price),
      });
    }

  }

}