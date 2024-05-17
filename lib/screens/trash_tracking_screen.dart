import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/apartment_model.dart';
import '../models/flat_model.dart';
import '../models/user_model.dart';
import '../utils/utils.dart';
import '../services/auth_supplier.dart';
import 'multiple_flat_user_profile_screen.dart';

class TrashTrackingScreen extends StatefulWidget {
  const TrashTrackingScreen({Key? key}) : super(key: key);

  @override
  TrashTrackingScreenState createState() => TrashTrackingScreenState();
}

class TrashTrackingScreenState extends State<TrashTrackingScreen> {
  late List<UserModel> users;
  List<int> floors = [];
  bool _isLoading = true;
  String? selectedApartment;

  @override
  void initState() {
    super.initState();
    users = [];
    updateFloorAndFlatLists(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Çöp Takibi',
            style: TextStyle(
              fontSize: 26,
            ),
          ),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
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
                    MaterialPageRoute(builder: (context) => const WelcomeScreen(),
                    ),
                  ),
                  );
                },
                icon: const Icon(Icons.exit_to_app)
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
                .where('floorNo', isEqualTo: floor.toString())
                .where('garbage', isEqualTo: true)
                .where('apartmentId', isEqualTo: selectedApartment)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else {
                bool hasGarbage = snapshot.data!.docs.isNotEmpty;
                return Icon(
                  hasGarbage ? Icons.check_circle : Icons.close,
                  color: hasGarbage ? Colors.green : Colors.red,
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
                .where('garbage', isEqualTo: true)
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
                return Column(
                  children: flats.map((flat) {
                    return ListTile(
                      title: Text('Daire ${flat.flatNo}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () => _removeGarbage(flat.flatId),
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

  void _removeGarbage(String flatId) {
    FirebaseFirestore.instance.collection('flats').doc(flatId).update({
      'garbage': false,
    }).then((value) {
      // Send notification to resident
      sendNotificationToResident(flatId,'Çöpünüz atıldı.');
      Navigator.pop(context);
      showSnackBar('Çöp atıldı.');
    }).catchError((error) {
      showSnackBar('Çöp atımında hata oldu.');
    });
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
