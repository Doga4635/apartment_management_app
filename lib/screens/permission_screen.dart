import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flat_model.dart';
import '../models/user_model.dart';
import '../utils/utils.dart';
import 'multiple_flat_user_profile_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  PermissionScreenState createState() => PermissionScreenState();
}

class PermissionScreenState extends State<PermissionScreen> {
  String? apartmentName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bekleyen İzinler', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen(isAllowed: true)));
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
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: getApartmentIdForUser(ap.userModel.uid),
          builder: (context, apartmentIdSnapshot) {
            if (apartmentIdSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (apartmentIdSnapshot.hasError) {
              return const Text('Apartman adı alınırken sorun oluştu.');
            } else {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('flats')
                    .where('isAllowed', isEqualTo: false)
                    .where('apartmentId', isEqualTo: apartmentIdSnapshot.data)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Veriler alınırken hata oluştu.');
                  } else {
                    List<FlatModel> flats = snapshot.data!.docs
                        .map((doc) => FlatModel.fromSnapshot(doc))
                        .toList();
                    return ListView.builder(
                      itemCount: flats.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<UserModel?>(
                          future: getUserById(flats[index].uid),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (userSnapshot.hasError) {
                              return const Text('Error fetching user data');
                            } else {
                              UserModel? user = userSnapshot.data;
                              if (user != null) {
                                return ListTile(
                                  title: Text(user.name),
                                  leading: Text('No: ${flats[index].flatNo}',style: const TextStyle(fontSize: 14),),
                                  subtitle: Text(flats[index].role),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.check, color: Colors.teal),
                                          onPressed: () => _removeFlat(flats[index].flatId, true),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          onPressed: () => _removeFlat(flats[index].flatId, false),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const Text('User not found');
                              }
                            }
                          },
                        );
                      },
                    );

                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _removeFlat(String flatId, bool isAllowed) {
    FirebaseFirestore.instance.collection('flats').doc(flatId).update({
      'isAllowed': isAllowed,
    }).then((value) {
      setState(() {
        showSnackBar('Çöp atıldı.');
      });
    }).catchError((error) {
      showSnackBar('Çöp atımında hata oldu.');
    });
  }
}


