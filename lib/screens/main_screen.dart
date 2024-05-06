import 'dart:io';


import 'package:apartment_management_app/screens/apartment_payment_screen.dart';
import 'package:apartment_management_app/screens/first_module_screen.dart';
import 'package:apartment_management_app/screens/permission_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'ana_menü_yardım_screen.dart';
import 'annoucement_screen.dart';
import 'multiple_flat_user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isAllowed;
  const MainScreen({super.key, required this.isAllowed});

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
        title: const Text('Ana Menü', style: TextStyle(fontSize: 28)),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
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
        print(userRole);
        return userRole == 'Apartman Yöneticisi' ? IconButton(
          onPressed: () async {
            String apartmentName = ap.userModel.apartmentName;

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
            child: widget.isAllowed ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (
                          context) => const FirstModuleScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(290, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Kapıcı İşlemleri",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (
                          context) => const ApartmentPaymentScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(290, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Bireysel Ödeme İşlemleri",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(290, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Apartman Muhasebe İşlemleri",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ) : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.only(left: 24.0,top: 5.0,right: 24.0,bottom: 5.0),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: const Text('Henüz daire girişiniz yönetici tarafından onaylanmadı.',
                  style: TextStyle(color: Colors.white,fontSize: 36),
                ),),
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
      MaterialPageRoute(builder: (context) => const YardimScreen()),
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