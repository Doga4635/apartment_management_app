import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../utils/utils.dart';

class TrashTrackingScreen extends StatefulWidget {
  const TrashTrackingScreen({super.key});

  @override
  TrashTrackingScreenState createState() => TrashTrackingScreenState();
}

class TrashTrackingScreenState extends State<TrashTrackingScreen> {
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    getUsers();
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
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const UserProfileScreen()));
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
              onPressed: () {
                ap.userSignOut().then((value) =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    ),
                );
              },
              icon: const Icon(Icons.exit_to_app)
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: buildUserListView()), // Add Expanded widget here
            ],
          ),
        ),
      ),
    );
  }

  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      users = querySnapshot.docs
          .where((doc) => doc['garbage'] == true)
          .map((doc) {
        return UserModel(
          uid: doc['uid'] ?? '',
          name: doc['name'] ?? '',
          profilePic: doc['profilePic'] ?? '',
          role: doc['role'] ?? '',
          apartmentName: doc['apartmentName'] ?? '',
          flatNumber: doc['flatNumber'] ?? '',
          garbage: doc['garbage'] ?? '',
        );
      }).toList();

      return users;
    } catch (e) {
      // Handle error fetching users
      showSnackBar('Error fetching users: $e');
      return [];
    }
  }

  Widget buildUserListView() {
    return FutureBuilder<List<UserModel>>(
      future: getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if fetching data fails
        } else {
          users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Call a function to delete the user
                    deleteUser(users[index].uid);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  void deleteUser(String uid) async {
    // Update the user's garbage status in Firestore
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'garbage': false,
      });

      // Update the UI by removing the user from the list
      setState(() {
        users.removeWhere((user) => user.uid == uid);
      });

      // Optionally, show a success message
      showSnackBar('User deleted successfully');
    } catch (e) {
      // Handle errors
      showSnackBar('Error deleting user: $e');
    }
  }

}
