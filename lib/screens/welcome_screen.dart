import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/register_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/payment_model.dart';
import '../utils/utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const route = '/welcome-screen';

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? userRole;

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
    return  GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // You can adjust the radius as needed
                      child: Image.asset(
                        "images/apartcom.png",
                        fit: BoxFit.cover, // Optional, adjust as needed
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 6.0),
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
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                        "Eğer bir apartmanda yaşıyorsan şimdi başla.",
                        style: TextStyle(color: Colors.black,fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:  () async {
                      if(ap.isSignedIn == true) {
                        bool isAllowed = await getAllowedForUser(FirebaseAuth.instance.currentUser!.uid);
                        checkPaymentsAndNotifyResidents();
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
        ),
      ),
    );
  }

  Future<void> checkPaymentsAndNotifyResidents() async {

    try {
      // Fetch payments from Firestore
      QuerySnapshot paymentSnapshot = await FirebaseFirestore.instance.collection('paymentss').get();

      for (var paymentDoc in paymentSnapshot.docs) {
        PaymentModel payment = PaymentModel(
          id: paymentDoc['id'],
          name: paymentDoc['name'],
          apartmentId: paymentDoc['apartmentId'],
          description: paymentDoc['description'],
          price: paymentDoc['price'],
          flatNo: paymentDoc['flatNo'],
          paid: paymentDoc['paid'],
          dueDate: paymentDoc['dueDate'],
        );

        Timestamp now = Timestamp.now();
        final int daysInMilliseconds = 2 * 24 * 60 * 60 * 1000;
        Timestamp twoDaysBeforeDueDate = Timestamp.fromMillisecondsSinceEpoch(
            payment.dueDate.millisecondsSinceEpoch - daysInMilliseconds);
        // Check if the payment is not paid and the due date is within 2 days
        if (!payment.paid && twoDaysBeforeDueDate.compareTo(now) < 0) {
          // Fetch the flat information
          QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
              .collection('flats')
              .where('flatNo', isEqualTo: payment.flatNo)
              .where('apartmentId', isEqualTo: payment.apartmentId)
              .where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get();

          if (flatSnapshot.docs.isNotEmpty) {
            String flatId = flatSnapshot.docs.first['flatId'];
            sendNotificationToResident(flatId, '${payment.name} ödemesinin son tarihine 2 günden az zaman kaldı.');
          }
        }
      }
    } catch (e) {
      print('Error checking payments and sending notifications: $e');
    }
  }
}
