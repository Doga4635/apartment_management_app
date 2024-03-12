import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flat_model.dart';
import '../models/user_model.dart';
import '../utils/utils.dart';
import '../services/auth_supplier.dart';

class TrashTrackingScreen extends StatefulWidget {
  const TrashTrackingScreen({Key? key}) : super(key: key);

  @override
  TrashTrackingScreenState createState() => TrashTrackingScreenState();
}

class TrashTrackingScreenState extends State<TrashTrackingScreen> {
  late List<UserModel> users;

  @override
  void initState() {
    super.initState();
    users = [];
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Çöp Takibi',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              );
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
                .where('garbage', isEqualTo: true)
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

  void _showFloorDetails(String floor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$floor. Kat Daireleri'),
          content: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('flats')
                .where('floorNo', isEqualTo: floor)
                .where('garbage', isEqualTo: true)
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
      Navigator.pop(context);
      showSnackBar('Çöp atıldı.');
    }).catchError((error) {
      showSnackBar('Error removing garbage');
    });
  }

}
