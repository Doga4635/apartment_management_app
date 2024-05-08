import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flat_model.dart';
import '../models/user_model.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'flat_screen.dart';
import 'multiple_flat_user_profile_screen.dart';


class DagitimScreen extends StatefulWidget {
  const DagitimScreen({Key? key}) : super(key: key);


  @override
  TrashTrackingScreenState createState() => TrashTrackingScreenState();
}


class TrashTrackingScreenState extends State<DagitimScreen> {
  late List<UserModel> users;
  late String _currentDay;

  @override
  void initState() {
    super.initState();
    users = [];
  }
  // Function to update the current day
  void _updateCurrentDay() {
    final now = DateTime.now();
    // Convert the current date to a string representation of the day (e.g., Monday, Tuesday, etc.)
    _currentDay = getDayOfWeek(now.weekday);
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dağıtım',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
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
                  MaterialPageRoute(builder: (context) => MultipleFlatUserProfileScreen()),
                );
              }
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Build floor list with garbage status icons
              buildFloorList(),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildFloorList() {
    // Assume you have 5 floors
    List<String> floors = ['1', '2', '3', '4', '5'];


    return Column(
      children: floors.map((floor) {
        return ListTile(
          title: Text('$floor. Kat'),
          trailing: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('flats')
                .where('floorNo', isEqualTo: floor)
                .where('grocery', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else {
                bool hasGrocery = snapshot.data!.docs.isNotEmpty;
                return Icon(
                  hasGrocery ? Icons.check_circle : Icons.cancel,
                  color: hasGrocery ? Colors.green : Colors.red,
                );
              }
            },
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('$floor. Kat'),
                      ElevatedButton(
                        onPressed: () async {
                          String flatId = await fetchFirstFlatIdForFloor(floor);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlatScreen(
                                  flats: [],

                                ),
                              ),
                            );

                        },
                        child: const Text('Daire 1'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String flatId = await fetchFirstFlatIdForFloor(floor);

                          if (flatId.isNotEmpty) {
                            FlatModel flatModel = await FirebaseFirestore.instance
                                .collection('flats')
                                .where('flatId', isEqualTo: flatId)
                                .limit(1)
                                .get()
                                .then((querySnapshot) => FlatModel.fromSnapshot(querySnapshot.docs.first));

                            String apartmentId = flatModel.apartmentId;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlatScreen(
                                  flats: [],

                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Daire 2'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String flatId = await fetchFirstFlatIdForFloor(floor);

                          if (flatId.isNotEmpty) {
                            FlatModel flatModel = await FirebaseFirestore.instance
                                .collection('flats')
                                .where('flatId', isEqualTo: flatId)
                                .limit(1)
                                .get()
                                .then((querySnapshot) => FlatModel.fromSnapshot(querySnapshot.docs.first));

                            String apartmentId = flatModel.apartmentId;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlatScreen(
                                  flats: [],

                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Daire 3'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String flatId = await fetchFirstFlatIdForFloor(floor);

                          if (flatId.isNotEmpty) {
                            FlatModel flatModel = await FirebaseFirestore.instance
                                .collection('flats')
                                .where('flatId', isEqualTo: flatId)
                                .limit(1)
                                .get()
                                .then((querySnapshot) => FlatModel.fromSnapshot(querySnapshot.docs.first));

                            String apartmentId = flatModel.apartmentId;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlatScreen(
                                  flats: [],                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Daire 4'),
                      ),
                     ],
                  ),
                );
              },
            );
          },
        );
      }).toList(),
    );
  }

  Future<void> displayOrdersForFlat(BuildContext context, String flatNo, String floorNo, String apartmentId) async {
    final List<Map<String, dynamic>> orders = await getOrdersForFlat(flatNo, floorNo, _currentDay, apartmentId);

    if (orders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No orders found for this flat')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Orders for Flat $flatNo'),
          content: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              final Map<String, dynamic> order = orders[index];
              return ListTile(
                title: Text(order['name']),
                subtitle: Text('${order['amount']} x ${order['price']}'),
              );
            },
          ),
        );
      },
    );
  }
}