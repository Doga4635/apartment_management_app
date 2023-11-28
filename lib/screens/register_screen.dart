import 'package:apartment_management_app/screens/code_enter_screen.dart';
import 'package:flutter/material.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  void initState() {
    super.initState();
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.home,
                  size: 120,
                  color: Colors.teal,
                ),
                Text(
                  'Register',
                  style: TextStyle(
                    color: customTealShade900,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Create a New Account',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: TextField(
                    style: TextStyle(
                      color: customTealShade900,
                      fontSize: 20.0,
                      fontFamily: 'Source Sans Pro',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: customTealShade900),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: customTealShade900,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: customTealShade900),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      print(value);
                    },
                  ),),
                ElevatedButton(
                  child: Text(
                    'Continue',
                  ),
                  onPressed:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CodeEnterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 70.0,vertical: 15.0),
                  ),
                ),
              ],
            ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Help',
        child: const Icon(Icons.question_mark),
        backgroundColor: Colors.teal,
      ),
          );
  }
}