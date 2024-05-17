import 'package:apartment_management_app/screens/grocery_list_screen.dart';
import 'package:apartment_management_app/screens/trash_tracking_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:apartment_management_app/utils/utils.dart';
import '../services/auth_supplier.dart';
import 'alisveris_listesi_screen.dart';
import 'ana_menü_yardım_screen.dart';
import 'annoucement_screen.dart';
import 'multiple_flat_user_profile_screen.dart';

class FirstModuleScreen extends StatefulWidget {
  const FirstModuleScreen({Key? key}) : super(key: key);

  @override
  FirstModuleScreenState createState() => FirstModuleScreenState();
}

class FirstModuleScreenState extends State<FirstModuleScreen> {
  get createdList => null;
  bool _isLoading = true;
  bool isThereGarbage = false;

  @override
  void initState() {
    _getSwitch(isThereGarbage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final toggleSwitchProvider = Provider.of<ToggleSwitchProvider>(context, listen: false);
    final ap = Provider.of<AuthSupplier>(context,listen: false);

    return FutureBuilder<String>(
      future: ap.getField('role'), // Assuming 'role' is the field that contains the user's role
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(
            color: Colors.teal,
          ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String userRole = snapshot.data ?? ''; // Get the user's role from the snapshot
          return GestureDetector(
            onTap: () {
              // Dismiss the keyboard when user taps anywhere on the screen
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Kapıcı İşlemleri',
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
                child: _isLoading ? const Center(child: CircularProgressIndicator(
                  color: Colors.teal,
                )) : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 80.0,
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.teal, width: 1.0),
                        ),
                        child: Image.asset(
                          "images/kapıcı.png",
                            fit: BoxFit.cover
                        ),
                      ),
                      const SizedBox(height: 100),
                      ElevatedButton(
                        onPressed: () {
                          if(userRole == "Kapıcı") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AlisverisListesiScreen()),
                            );
                          }
                          else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GroceryListScreen()),
                            );                      }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: Size(320,50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Sharp edges
                          ),
                        ),
                        child: const Text(
                          'Kapıcıya Alışveriş Listesi',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      userRole == 'Kapıcı' // Show button for 'Doorman'
                          ? ElevatedButton(
                        onPressed: () {
                          // Handle button tap for Doorman
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TrashTrackingScreen()));

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: Size(280,60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Sharp edges
                          ),
                        ),
                        child: const Text(
                          'Çöp Takibi',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                          : Container(
                        height: 50.0,
                        width: 320.0,
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: FutureBuilder<bool>(
                          future: ap.getGarbage('garbage'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.teal,
                                  ));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              bool isThereGarbage = snapshot.data ?? false;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Text(
                                      "Çöpüm var",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  ToggleSwitch(
                                    minWidth: 60.0,
                                    minHeight: 35.0,
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      [Colors.green[800]!],
                                      [Colors.red[800]!]
                                    ],
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveFgColor: Colors.white,
                                    initialLabelIndex: isThereGarbage ? 0 : 1,
                                    totalSwitches: 2,
                                    labels: const ['Evet', 'Hayır'],
                                    radiusStyle: true,
                                    onToggle: (index) async {
                                      toggleSwitchProvider.setCurrentIndex(
                                          index!);
                                      if (index == 0) {
                                        _applyGarbage();
                                      }
                                      else {
                                        _removeGarbage();
                                      }
                                    },
                                  ),
                                ],
                              );
                            }
                          }
                        ),),
                    ],
                  ),
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AnnouncementScreen()),
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
                    heroTag: "btn2",
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
            ),
          );
        }
      },
    );
  }

  void _applyGarbage() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('flats')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('selectedFlat', isEqualTo: true)
      // buraya selectedFlat eklenecek
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          // Update the garbage field
          await firestore
              .collection('flats')
              .doc(doc.id)
              .update({'garbage': true});
        });
      });
      showSnackBar('Çöpünüzün olduğu kapıcıya bildirildi.');
    }
    catch (e) {
      showSnackBar('Çöpünüzün olduğunu bildirirken bir hata oluştu: $e');
    }
  }

  void _getSwitch(bool isThereGarbage) async {
    QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('selectedFlat', isEqualTo: true)
        .get();

    if (flatSnapshot.docs.isNotEmpty) {
      DocumentSnapshot flatDoc = flatSnapshot.docs.first;
      Map<String, dynamic>? userData = flatDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('garbage')) {
        bool garbage = userData['garbage'] as bool;
        isThereGarbage = garbage;
      }
      else {
        showSnackBar('Çöp durumu gözükmesinde hata var.');
      }
    } else {
      showSnackBar('Çöp durumu gözükmesinde hata var.');
    }

    setState(() {
      _isLoading = false;
    });

  }

  void _removeGarbage() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('flats')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      // buraya selectedFlat eklenecek
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          // Update the garbage field
          await firestore
              .collection('flats')
              .doc(doc.id)
              .update({'garbage': false});
        });
      });
      showSnackBar('Çöpünüzün olmadığı kapıcıya bildirildi.');
    }
    catch (e) {
      showSnackBar('Çöpünüzün olmadığını bildirirken bir hata oluştu: $e');
    }
  }

}

void createList({required bool saveList, required Null Function(dynamic createdList) onListCreated}) {
}

class ToggleSwitchProvider with ChangeNotifier {
  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

