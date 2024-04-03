import 'package:apartment_management_app/screens/user_payment_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../services/auth_supplier.dart';

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
        title: const Text('Ödeme Yap', style: TextStyle(
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const UserPaymentScreen()));
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Ödeme Yap',
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