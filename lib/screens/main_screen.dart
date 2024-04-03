<<<<<<< Updated upstream
=======
import 'dart:io';
import 'package:apartment_management_app/screens/first_module_screen.dart';
import 'package:apartment_management_app/screens/payment_screen.dart';
import 'package:apartment_management_app/screens/user_payment_screen_admin.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
>>>>>>> Stashed changes
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile picture
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(''),
              ),
<<<<<<< Updated upstream

              const SizedBox(height: 16.0),
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8.0),
              // User role
          Text(ap.userModel.role,
                style: TextStyle(fontSize: 18),
              ),
              
              // Name-Surname
              const SizedBox(height: 8.0),
              // Apartment name
              Text(ap.userModel.apartmentName,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8.0),
              // Flat Number
              Text(ap.userModel.flatNumber,
                style: const TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text(
                  "Add Address",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
=======
              child: const Text(
                "Kapıcı İşlemleri",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ApartmentPaymentScreen(),
                ),);
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(290, 40),
              ),
              child: const Text(
                "Bireysel Ödeme İşlemleri",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserPaymentScreenAdmin(),
                ),);
            },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text(
                "Apartman Muhasebe İşlemleri",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Yardım',
        backgroundColor: Colors.teal,
        child: const Icon(Icons.question_mark,
          color: Colors.white,
>>>>>>> Stashed changes
        ),
      ),
    );
  }

  EditProfileButton({required Null Function() onPressed}) {}


}