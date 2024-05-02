import 'package:apartment_management_app/screens/define_payment_screen.dart';
import 'package:apartment_management_app/screens/done_payment_screen.dart';
import 'package:apartment_management_app/screens/user_payment_screen.dart';
import 'package:apartment_management_app/screens/user_payment_screen_admin.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';

class ApartmentPaymentScreen extends StatefulWidget {
  const ApartmentPaymentScreen({Key? key}) : super(key: key);

  @override
  _ApartmentPaymentScreenState createState() => _ApartmentPaymentScreenState();
}

class _ApartmentPaymentScreenState extends State<ApartmentPaymentScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödeme Ekranı', style: TextStyle(
          fontSize: 28,
        ),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                ap.userSignOut().then((value) =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    ),
                );
              },
              icon: const Icon(Icons.exit_to_app)),
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
                onTap: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
                  final userData = await userDoc.get();
                  final userModel = UserModel.fromMap(userData.data()!);
                  if (userModel.role == 'Apartman Yöneticisi') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const DefinePaymentScreen()));
                  } else {
                    showSnackBar('Sadece apartman yöneticileri bu sayfaya erişebilir.');
                  }
                },
                child: Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Ödeme Tanımlama Ekranı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const UserPaymentScreen()));
                },
                child: Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Ödeme Takip Ekranı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const DonePaymentScreen()));
                  // Add your functionality here

                },
                child: Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Yapılmış Ödemeler',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}