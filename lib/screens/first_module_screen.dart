import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:apartment_management_app/utils/utils.dart';

import '../services/auth_supplier.dart';

class FirstModuleScreen extends StatefulWidget {
  const FirstModuleScreen({super.key});

  @override
  FirstModuleScreenState createState() => FirstModuleScreenState();
}

class FirstModuleScreenState extends State<FirstModuleScreen> {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final toggleSwitchProvider = Provider.of<ToggleSwitchProvider>(context, listen: false);
    final ap = Provider.of<AuthSupplier>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kapıcı İşlemleri',style: TextStyle(
          fontSize: 26,
        ),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen()));
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
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 80.0,
            ),
            Container(
              height: 180,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Image.asset("images/kapıcı.jpg",
                fit:BoxFit.contain,
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              minimumSize: const Size(300, 45)),
              child: const Text(
                "Kapıcıya Alışveriş Listesi",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              height: 45.0,
              width: 300.0,
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
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
                    activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: toggleSwitchProvider.currentIndex,
                    totalSwitches: 2,
                    labels: const ['Evet', 'Hayır'],
                    radiusStyle: true,
                    onToggle: (index) async {
                      toggleSwitchProvider.setCurrentIndex(index!);
                      if(index == 0) {
                        try {
                          await _firebaseFirestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                              {'garbage': true});
                          showSnackBar('Çöpünüzün olduğu kapıcıya bildirildi.');
                        } catch (e) {
                          showSnackBar('Çöpünüzün olduğunu bildirirken bir hata oluştu: $e');
                        }
                      }
                      else {
                        try {
                          await _firebaseFirestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                              {'garbage': false});
                        } catch (e) {
                          showSnackBar('Çöpünüzün olmadığını bildirirken bir hata oluştu: $e');
                        }
                      }
                    },
                  ),
                ],
              ),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Yardım',
        backgroundColor: Colors.teal,
        child: const Icon(Icons.question_mark,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ToggleSwitchProvider with ChangeNotifier {
  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
