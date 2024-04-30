import 'dart:io';
import 'package:apartment_management_app/screens/add_flat_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'ana_menü_yardım_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  File? image;

  @override
  void initState() {
    super.initState();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    String currentUserUid = ap.userModel.uid;
    Future<String?> apartmentName = getUserApartmentName(currentUserUid);
    Future<String?> role = getUserRole(currentUserUid);
    Future<String?> flatNumber = getUserFlatNumber(currentUserUid);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.angleLeft),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        ap.userModel.name,
                        style: const TextStyle(fontSize: 32),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    const SizedBox(height: 8.0),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder<String?>(
                        future: role,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              snapshot.data ?? '',
                              style: const TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder<String?>(
                        future: apartmentName,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              snapshot.data ?? '',
                              style: const TextStyle(fontSize: 22),
                              textAlign: TextAlign.left,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder<String?>(
                        future: flatNumber,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            const  String defaultText = 'Daire: '; // Prefix text
                            final String flatNumberText = snapshot.data ?? '';

                            return Text(
                              '$defaultText$flatNumberText', // Concatenate the prefix with flat number
                              style: const TextStyle(fontSize: 22),
                            );
                          }
                        },
                      ),
                    ),


                  ],

                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddFlatScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(210, 40),
                ),
                child: const Text(
                  "Daire Ekle",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const YardimScreen()),
                );
              },
              tooltip: 'Yardım',
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.question_mark,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getUserApartmentName(String currentUserUid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUserUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('apartmentName')) {
        String apartmentName = userData['apartmentName'] as String;
        return apartmentName;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String?> getUserRole(String currentUserUid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUserUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('role')) {
        String role = userData['role'] as String;
        return role;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String?> getUserFlatNumber(String currentUserUid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUserUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('flatNumber')) {
        String flatNumber = userData['flatNumber'] as String;
        return flatNumber;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  editProfileButton({required Null Function() onPressed}) {}
}
