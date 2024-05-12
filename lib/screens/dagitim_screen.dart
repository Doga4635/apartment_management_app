import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/apartment_model.dart';
import '../models/flat_model.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'flat_screen.dart';
import 'multiple_flat_user_profile_screen.dart';


class DagitimScreen extends StatefulWidget {
  const DagitimScreen({Key? key}) : super(key: key);


  @override
  DagitimScreenState createState() => DagitimScreenState();
}


class DagitimScreenState extends State<DagitimScreen> {
  late String _currentDay;
  List<int> floors = [];
  bool _isLoading = true;
  String? selectedApartment;
  late String apartmentId;
  double totalApartmentBalance = 0;


  @override
  void initState() {
    super.initState();
    updateFloorAndFlatLists(FirebaseAuth.instance.currentUser!.uid);
    _updateCurrentDay();
    fetchTotalApartmentBalance();
  }
  // Function to update the current day
  void _updateCurrentDay() {
    final now = DateTime.now();
    // Convert the current date to a string representation of the day (e.g., Monday, Tuesday, etc.)
    _currentDay = getDayOfWeek(now.weekday);
  }

  Future<void> fetchTotalApartmentBalance() async {
    try {
      double totalBalance = 0;

      // Query all flats in the apartment
      QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
          .collection('flats')
          .where('apartmentId', isEqualTo: apartmentId)
          .get();

      // Calculate the total balance by summing up balances from all flats
      flatSnapshot.docs.forEach((doc) {
        totalBalance += (doc['balance'] ?? 0).toDouble(); // Add balance to totalBalance
      });

      setState(() {
        totalApartmentBalance = totalBalance;
      });

      print('Total apartment balance fetched successfully.');
    } catch (error) {
      print('Error fetching total apartment balance: $error');
    }
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
                  MaterialPageRoute(builder: (context) => const MultipleFlatUserProfileScreen()),
                );
              }
              else {
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
      body: SafeArea(
        child: _isLoading == true ? const Center(child: CircularProgressIndicator(
          color: Colors.teal,
        )) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Build floor list with garbage status icons
              buildFloorList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Text(
              'Toplam Bakiye: ${totalApartmentBalance.toStringAsFixed(2)} TL',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }



  Widget buildFloorList() {

    return Column(
      children: floors.map((floor) {
        return ListTile(
          title: Text('$floor. Kat'),
          trailing: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('floorNo', isEqualTo: floor.toString())
                .where('apartmentId', isEqualTo: selectedApartment!)
                .where('days', arrayContains: _currentDay)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else {
                bool hasGrocery = snapshot.data!.docs.isNotEmpty;
                return Icon(
                  hasGrocery ? Icons.check_circle : Icons.close,
                  color: hasGrocery ? Colors.green : Colors.red,
                );
              }
            },
          ),
          onTap: () => _showFloorDetails(floor),
        );
      }).toList(),
    );
  }

  void _showFloorDetails(int floor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$floor. Kat Daireleri'),
          content: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('flats')
                .where('floorNo', isEqualTo: floor.toString())
                .where('apartmentId', isEqualTo: selectedApartment)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error fetching data');
              } else {
                List<FlatModel> flats = snapshot.data!.docs
                    .map((doc) => FlatModel.fromSnapshot(doc))
                    .toList();
                flats.sort((a, b) => int.parse(a.flatNo).compareTo(int.parse(b.flatNo)));
                return flats.isEmpty ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 24.0,right: 8.0,top: 8.0,bottom: 8.0),
                      child: Text(
                        'Bu katta kayıtlı daire bulunmamaktadır.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ) :
                Column(
                  children: flats.map((flat) {
                    return ListTile(
                      title: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FlatScreen(
                              apartmentId: flat.apartmentId,
                              floorNo: flat.floorNo,
                              flatNo: flat.flatNo, flatId: flat.flatId,
                            )),
                          );
                        },
                        child: Text('Daire ${flat.flatNo}',
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ),
                      trailing: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('floorNo', isEqualTo: floor.toString())
                              .where('flatNo', isEqualTo: flat.flatNo)
                              .where('apartmentId', isEqualTo: selectedApartment!)
                              .where('days', arrayContains: _currentDay)
                              .snapshots(),
                          builder: (context, grocerySnapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            } else {
                              bool hasGrocery = grocerySnapshot.data?.docs.isNotEmpty ?? false;
                              return Icon(
                                hasGrocery ? Icons.check_circle : Icons.close,
                                color: hasGrocery ? Colors.green : Colors.red,
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        );
      },
    );
  }

  void updateFloorAndFlatLists(String uid) async {
    floors.clear();

    selectedApartment = await getApartmentIdForUser(uid);
    QuerySnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('apartments')
        .where('name', isEqualTo: selectedApartment)
        .get();

    if (productSnapshot.docs.isNotEmpty) {
      // Get the first document
      var doc = productSnapshot.docs.first;

      ApartmentModel apartment = ApartmentModel(
        id: doc.id,
        name: doc['name'],
        floorCount: doc['floorCount'],
        flatCount: doc['flatCount'],
        managerCount: doc['managerCount'],
        doormanCount: doc['doormanCount'],
      );
      int floorNo = apartment.floorCount;

      for (int i = 1; i <= floorNo; i++) {
        floors.add(i);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }


}