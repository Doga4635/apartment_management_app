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
        backgroundColor: Colors.teal,
        title: const Text("Apartment Management App"),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(ap.userModel.role),
            Text(ap.userModel.apartmentName),
            Text(ap.userModel.flatNumber),
          ],
        ),
      ),
    );

  }

}