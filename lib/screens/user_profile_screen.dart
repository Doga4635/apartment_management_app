import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final roleController = TextEditingController();
  final apartmentController = TextEditingController();
  final flatNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    roleController.dispose();
    apartmentController.dispose();
    flatNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(

          ),
        ),
      ),
    );
  }
}
