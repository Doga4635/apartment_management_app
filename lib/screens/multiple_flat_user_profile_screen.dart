import 'package:apartment_management_app/screens/add_flat_screen.dart';
import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'ana_menü_yardım_screen.dart';

class MultipleFlatUserProfileScreen extends StatefulWidget {
  const MultipleFlatUserProfileScreen({super.key});

  @override
  MultipleFlatUserProfileScreenState createState() => MultipleFlatUserProfileScreenState();
}

class MultipleFlatUserProfileScreenState extends State<MultipleFlatUserProfileScreen> {
  List<String> flatList = [];
  List<String> flatIDList = [];
  List<String> apartmentList = [];

  @override
  void initState() {
    super.initState();
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    getCurrentUserFlats(currentUserUid, flatList, flatIDList, apartmentList).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    String currentUserUid = ap.userModel.uid;
    Future<String?> apartmentName = getUserApartmentName(currentUserUid);
    Future<String?> role = getUserRole(currentUserUid);
    Future<String?> flatNumber = getUserFlatNumber(currentUserUid);

    void deleteFlat(int index) async {
      String flatIdToDelete = flatIDList[index];
      // Delete the flat document from Firestore
      await FirebaseFirestore.instance.collection('flats').doc(flatIdToDelete).delete();

      // Remove the flat from the lists
      setState(() {
        flatList.removeAt(index);
        flatIDList.removeAt(index);
        apartmentList.removeAt(index);
      });

      showSnackBar('Daire başarılı bir şekilde silindi.');
    }

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
                            const String defaultText = 'Daire: '; // Prefix text
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

              const SizedBox(height: 28.0),

              Expanded(
                child:Container(
                  width: 350.0,
                  height: 330.0,


                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),

                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: flatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[50],
                                  minimumSize: const Size(250, 85),
                                ),
                                onPressed: () async {
                                  String selectedFlatId = flatIDList[index];
                                  await updateSelectedFlatIdentityFalse(currentUserUid);
                                  await updateSelectedFlatIdentityTrue(currentUserUid, selectedFlatId);
                                  updateUserIdentity(currentUserUid, selectedFlatId);
                                  getAllowedForUser(currentUserUid).then((value) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();

                                    /*
                                  setState(() {
                                    apartmentName = getUserApartmentName(currentUserUid);
                                    role = getUserRole(currentUserUid);
                                    flatNumber = getUserFlatNumber(currentUserUid);
                                  });
                                  */

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MainScreen(isAllowed: value)),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Daire başarıyla değiştirildi.'),
                                    ));
                                  });



                                },
                                child: Text(
                                  '${apartmentList[index]}\n Daire: ${flatList[index]}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Daireyi Sil"),
                                      content: const Text("Bu daireyi silmek istediğinizden emin misiniz?"),
                                      actions: [
                                        ElevatedButton(
                                          child: const Text("İptal"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          child: const Text("Sil"),
                                          onPressed: () {
                                            deleteFlat(index);
                                            Navigator.of(context).pop();
                                            if (flatList.isEmpty){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                                              );
                                            }

                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 30,
                            ),



                          ],
                        ),
                      );
                    },
                  ),



                ),
              ),

              const SizedBox(height: 30.0),



              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddFlatScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(210, 50),
                ),
                child: const Text(
                  "Daire Ekle",
                  style: TextStyle(
                    fontSize: 30,
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

  editProfileButton({required Null Function() onPressed}) {}
}

Future<void> updateSelectedFlatIdentityFalse(String currentUserUid) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('flats')
      .where('uid', isEqualTo: currentUserUid)
      .where('selectedFlat', isEqualTo: true)
      .get();

  querySnapshot.docs.forEach((doc) async {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('flats').doc(doc.id);
    await documentReference.update({'selectedFlat': false});
  });
}

Future<void> updateSelectedFlatIdentityTrue(String currentUserUid, String flatId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('flats')
      .where('uid', isEqualTo: currentUserUid)
      .where('flatId', isEqualTo: flatId)
      .get();

  querySnapshot.docs.forEach((doc) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flats').doc(doc.id);
    await documentReference.update({'selectedFlat': true});
  });
}

Future<void> updateUserIdentity(String currentUserUid, String flatId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('flats')
      .where('flatId', isEqualTo: flatId)
      .get();

  querySnapshot.docs.forEach((doc) async {
    String role = doc['role'];
    String apartmentId = doc['apartmentId'];
    String flatNo = doc['flatNo'];

    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUserUid)
        .get();

    querySnapshot2.docs.forEach((doc) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(doc.id);
      await documentReference.update({'role': role});
      await documentReference.update({'apartmentName': apartmentId});
      await documentReference.update({'flatNumber': flatNo});
    });
  });
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

Future<String?> getCurrentUserFlats(String currentUserUid, List<String> flatList, List<String> flatIDList, List<String> apartmentList) async {

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('flats')
      .where('uid', isEqualTo: currentUserUid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        String? flatID = data['flatId'] as String?;
        String? apartmentId = data['apartmentId'] as String?;
        String? flatNo = data['flatNo'] as String?;
        bool selectedFlat = data['selectedFlat'] as bool? ?? false; // Get selectedFlat property or default to false
        if (apartmentId != null && flatID != null && flatNo != null && !selectedFlat) { // Check if the flat is not selected
          apartmentList.add(apartmentId);
          flatIDList.add(flatID);
          flatList.add(flatNo);
        }

      }
    }
  } else {
    showSnackBar('No documents found for the current user.');
  }
  return null;
}








