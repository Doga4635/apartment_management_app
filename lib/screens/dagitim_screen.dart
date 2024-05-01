import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/apartment_model.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'multiple_flat_user_profile_screen.dart';

class DagitimScreen extends StatefulWidget {
  const DagitimScreen({Key? key}) : super(key: key);

  @override
  TrashTrackingScreenState createState() => TrashTrackingScreenState();
}

class TrashTrackingScreenState extends State<DagitimScreen> {
  List<String> users = [];
  List<int> floors = [];
  Map<int,List<String>> floorToFlats = {};
  bool _isLoading = true;
  late Future<void> _future;
  List<String> flats = [];

  @override
  void initState() {
    super.initState();
    getUsers();
    _future = updateFloorAndFlatLists(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> updateFloorAndFlatLists(String uid) async {
    // Clear floor and flat lists
    floors.clear();

    String? selectedApartment = await getApartmentIdForUser(uid);
    QuerySnapshot apartmentSnapshot = await FirebaseFirestore.instance
        .collection('apartments')
        .where('name', isEqualTo: selectedApartment)
        .get();

    if (apartmentSnapshot.docs.isNotEmpty) {
      // Get the first document
      var doc = apartmentSnapshot.docs.first;

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
        flats.clear();
        floors.add(i);
        QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
            .collection('flats')
            .where('apartmentId', isEqualTo: selectedApartment)
            .where('floorNo', isEqualTo: i.toString())
            .get();

        for(var doc in flatSnapshot.docs) {
          String flatNumber = doc['flatNo'];
          flats.add(flatNumber);
        }

        floorToFlats[i] = flats;
        print(floorToFlats[i]);

      }
    }
    setState(() {
      // Set loading state to false after fetching data
      _isLoading = false;
    });
  }

  void getUsers() async {
    users.clear();

    String? selectedApartment = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('apartmentId', isEqualTo: selectedApartment)
        .get();

    for (var doc in flatSnapshot.docs) {
      users.add(doc['uid']);
    }

    setState(() {
      // Set loading state to false after fetching data
      _isLoading = false;
    });

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
        actions: [
          IconButton(
            onPressed: () async {

              String currentUserUid = ap.userModel.uid;

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
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildFloorList(),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
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
              print(floorToFlats[1]);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('$floor. Kat'),
                      Column(
                        children: floorToFlats[floor]!.map((flatNo) {
                        return ElevatedButton(
                          onPressed: () {

                          },
                          child: Text('Daire $flatNo'),
                        );
                      }).toList(),
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


}