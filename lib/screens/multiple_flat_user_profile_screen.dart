import 'dart:io';
import 'package:apartment_management_app/screens/add_flat_screen.dart';
import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MultipleFlatUserProfileScreen extends StatefulWidget {
  const MultipleFlatUserProfileScreen({Key? key});

  @override
  MultipleFlatUserProfileScreenState createState() => MultipleFlatUserProfileScreenState();
}

class MultipleFlatUserProfileScreenState extends State<MultipleFlatUserProfileScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => selectImage(),
                child: image == null
                    ? const CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 60,
                  child: Icon(
                    Icons.account_circle,
                    size: 70,
                    color: Colors.white,
                  ),
                )
                    : CircleAvatar(
                  backgroundImage: FileImage(image!),
                  radius: 60,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                ap.userModel.name,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<String?>(
                future: role,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(fontSize: 18),
                    );
                  }
                },
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<String?>(
                future: apartmentName,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(fontSize: 18),
                    );
                  }
                },
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<String?>(
                future: flatNumber,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(fontSize: 18),
                    );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text(
                  "Profili Düzenle",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
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
              ElevatedButton(
                onPressed: () async {
                  String currentUserUid = ap.userModel.uid;

                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('flats')
                      .where('uid', isEqualTo: currentUserUid)
                      .get();

                  List<String> flatList = [];
                  List<String> flatIDList = [];

                  if (querySnapshot.docs.isNotEmpty) {
                    querySnapshot.docs.forEach((doc) {
                      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
                      if (data != null) {
                        String? flatID = data['flatId'] as String?;
                        String? apartmentId = data['apartmentId'] as String?;
                        if (apartmentId != null && flatID != null) {
                          flatList.add(apartmentId);
                          flatIDList.add(flatID);
                        }
                      }
                    });
                  } else {
                    print('No documents found for the current user.');
                  }

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Daire Seçiniz"),
                        content: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: flatList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(flatList[index]),
                                onTap: () async {
                                  String selectedFlatId = flatIDList[index];
                                  updateSelectedFlatIdentityFalse(currentUserUid);
                                  updateSelectedFlatIdentityTrue(currentUserUid, selectedFlatId);
                                  updateUserIdentity(currentUserUid, selectedFlatId);
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
                                    MaterialPageRoute(builder: (context) => const MainScreen()),
                                  );

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Daire başarıyla değiştirildi.'),
                                    ));



                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(210, 40),
                ),
                child: const Text(
                  "Daire Değiştir",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Yardım',
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.question_mark,
          color: Colors.white,
        ),
      ),
    );
  }

  editProfileButton({required Null Function() onPressed}) {}
}

void updateSelectedFlatIdentityFalse(String currentUserUid) async {
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

void updateSelectedFlatIdentityTrue(String currentUserUid, String FlatId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('flats')
      .where('uid', isEqualTo: currentUserUid)
      .where('flatId', isEqualTo: FlatId)
      .get();

  querySnapshot.docs.forEach((doc) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flats').doc(doc.id);
    await documentReference.update({'selectedFlat': true});
  });
}

Future<void> updateUserIdentity(String currentUserUid, String FlatId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('flats')
      .where('flatId', isEqualTo: FlatId)
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
