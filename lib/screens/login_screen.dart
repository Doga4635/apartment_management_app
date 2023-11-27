import 'package:flutter/material.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Icon(
                Icons.home,
                size: 100,
                color: Colors.white,
              ),
              Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: customTealShade900,
                    ),
                    title: Text(
                      'doga@gmail.com',
                      style: TextStyle(
                        color: customTealShade900,
                        fontFamily: 'Source Sans Pro',
                        fontSize: 20.0,
                      ),
                    ),
                  )),
              Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: customTealShade900,
                    ),
                    title: Text(
                      '*********',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: customTealShade900,
                          fontFamily: 'Source Sans Pro'),
                    ),
                  )),
            ],
          )),
    );

  }

}