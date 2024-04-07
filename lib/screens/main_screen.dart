import 'dart:io';
import 'package:apartment_management_app/screens/ana_men%C3%BC_yard%C4%B1m_screen.dart';
import 'package:apartment_management_app/screens/first_module_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apartment_management_app/screens/annoucement_screen.dart';

import 'multiple_flat_user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('  Ana Menü',style: TextStyle(
          fontSize: 28,
        ),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
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
            icon: Icon(Icons.person),
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
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FirstModuleScreen(),
                ),);
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(290, 40),
              ),
              child: const Text(
                "Kapıcı İşlemleri",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(290, 40),
              ),
              child: const Text(
                "Bireysel Ödeme İşlemleri",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text(
                "Apartman Muhasebe İşlemleri",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnnoucementScreen()),
        );
            },
            tooltip: 'Duyuru',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.announcement,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            onPressed: () {Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => YardimScreen()),
    );},
            tooltip: 'Yardım',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.question_mark,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }


}