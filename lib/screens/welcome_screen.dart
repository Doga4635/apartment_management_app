import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/register_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const route = '/welcome-screen';

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming message when the app is in the foreground
      print('Received message: ${message.notification!.body}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification when the app is opened from a terminated state
      print('Opened from terminated state: ${message.notification!.body}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context,listen: false);
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.home,
                size: 130,
                color: Colors.teal,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "ApartCom",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                    "Eğer bir apartmanda yaşıyorsan şimdi başla.",
                    style: greyTextStyle
                ),
              ),
              ElevatedButton(
                onPressed:  () async {

                  if(ap.isSignedIn == true) {
                    bool isAllowed = await getAllowedForUser(FirebaseAuth.instance.currentUser!.uid);
                    await ap.getDataFromSP().whenComplete(() => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainScreen(isAllowed: isAllowed,))));
                  }
                  else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 70.0,vertical: 15.0),
                ),
                child: const Text(
                  'Başlayalım',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
