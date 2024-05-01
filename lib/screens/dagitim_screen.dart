import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/apartment_model.dart';
import '../models/user_model.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'multiple_flat_user_profile_screen.dart';

class DagitimScreen extends StatefulWidget {
  const DagitimScreen({Key? key}) : super(key: key);

  @override
  TrashTrackingScreenState createState() => TrashTrackingScreenState();
}

class TrashTrackingScreenState extends State<DagitimScreen> {
  late List<UserModel> users;
  List<int> floors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    users = [];
    updateFloorAndFlatLists(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    final isLoading = Provider.of<AuthSupplier>(context,listen: true).isLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dağıtım',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
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
        child: isLoading == true ? const Center(child: CircularProgressIndicator(
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
    );
  }

  Widget buildFloorList() {
    return Column(
      children: floors.map((floor) {
        return ListTile(
          title: Text('$floor. Kat'),
          trailing: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('flats')
                .where('floorNo', isEqualTo: floor)
                .where('grocery', isEqualTo: true)
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
                        onPressed: () {
                          // Handle button tap
                        },
                        child: const Text('Daire 1'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        child: const Text('Daire 2'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        child: const Text('Daire 3'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
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

  void updateFloorAndFlatLists(String uid) async {
    // Clear floor and flat lists
    floors.clear();


    String? selectedApartment = await getApartmentIdForUser(uid);
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
      // Set loading state to false after fetching data
      _isLoading = false;
    });
  }

}