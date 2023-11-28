import 'package:apartment_management_app/screens/register_flat_screen.dart';
import 'package:apartment_management_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CodeEnterScreen extends StatefulWidget {
  const CodeEnterScreen({super.key});

  @override
  _CodeEnterScreenState createState() => _CodeEnterScreenState();
}

class _CodeEnterScreenState extends State<CodeEnterScreen> {

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.sms,
              size: 120,
              color: Colors.teal,
            ),
            Text(
              'Enter the SMS Code',
              style: TextStyle(
                color: customTealShade900,
                fontSize: 28.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card containing TextField
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Container(
                    width: 250, // Adjust the width as needed
                    child: TextField(
                      style: TextStyle(
                        color: customTealShade900,
                        fontSize: 20.0,
                        fontFamily: 'Source Sans Pro',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Registration Code',
                        labelStyle: TextStyle(color: customTealShade900),
                        prefixIcon: Icon(
                          Icons.lock,
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
                    ),
                  ),
                ),
                SizedBox(width: 10.0), // Spacer between Card and button
                // Button
                TextButton(
                  child: Text(
                      'Resend a Code',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  ),
                ),
              ],
            ),
            Text(
              'Enter the code sent to your phone via SMS.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterFlatScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
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