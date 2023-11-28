import 'package:apartment_management_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterFlatScreen extends StatefulWidget {
  const RegisterFlatScreen({super.key});

  @override
  _RegisterFlatScreenState createState() => _RegisterFlatScreenState();
}

class _RegisterFlatScreenState extends State<RegisterFlatScreen> {

  @override
  void initState() {
    super.initState();
  }

  int _counter = 0;
  String selectedRoleValue = 'Role';
  String selectedApartmentName = 'Apartment Name';
  String selectedFlatNumber = 'Flat Number';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Row (
            children: [
              Expanded(child: Icon(
                Icons.person,
                size: 80.0,
                ),),
              Expanded(child: Column(
              children: [
                Expanded(
                    child: Text(
                      'Choose your Role',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
                Expanded(child: Text(
                 'What is your role in the apartment?',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                )
              ],
              ),),
            ],
          )),
          // DropdownButton<String>(
          //   value: selectedRoleValue,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       selectedRoleValue = newValue!;
          //     });
          //   },
          //   items: <String>['Resident', 'Doorman', 'Manager']
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          Expanded(child: Row (
            children: [
              Expanded(child: Icon(
                Icons.apartment,
                size: 80.0,
              ),),
              Expanded(child: Column(
                children: [
                  Expanded(
                    child: Text(
                      'Choose the Apartment',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Text(
                    'Which one is your apartment?',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  )
                ],
              ),),
            ],
          )),
          // DropdownButton<String>(
          //   value: selectedApartmentName,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       selectedApartmentName = newValue!;
          //     });
          //   },
          //   items: <String>['Cihan Apt.',]
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          Expanded(child: Row (
            children: [
              Expanded(child: Icon(
                Icons.home_filled,
                size: 80.0,
              ),),
              Expanded(child: Column(
                children: [
                  Expanded(
                    child: Text(
                      'Select your Flat Number',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Text(
                    'Which one is your flat number?',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  )
                ],
              ),),
            ],
          )),
          // DropdownButton<String>(
          //   value: selectedFlatNumber,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       selectedFlatNumber = newValue!;
          //     });
          //   },
          //   items: <String>['1',]
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
            ],
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