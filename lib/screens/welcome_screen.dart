import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/register_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
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
                size: 120,
                color: Colors.teal,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Let's get started",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "If you live in an apartment, start now.",
                  style: greyTextStyle
                ),
              ),
              ElevatedButton(
                onPressed:  () async {
                  if(ap.isSignedIn == true) {
                    await ap.getDataFromSP().whenComplete(() => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const MainScreen())));

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
                  'Get started',
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

