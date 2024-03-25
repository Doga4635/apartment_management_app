import 'dart:io';
import 'package:apartment_management_app/screens/add_flat_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MultipleFlatUserProfileScreen extends StatefulWidget {
  const MultipleFlatUserProfileScreen({super.key});

  @override
  MultipleFlatUserProfileScreenState createState() => MultipleFlatUserProfileScreenState();
}

class MultipleFlatUserProfileScreenState extends State<MultipleFlatUserProfileScreen> {
  File? image;

  @override
  void initState() {
    super.initState();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil',style: TextStyle(
          fontSize: 28,
        ),),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },icon: const Icon(FontAwesomeIcons.angleLeft),),

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
              InkWell(
                  onTap: () => selectImage(),
                  child: image == null ? const CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 60,
                    child: Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Colors.white,
                    ),
                  )
                      : CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 60,
                  )
              ),
              // Profile picture
              const SizedBox(height: 16.0),
              Text(
                ap.userModel.name,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8.0),
              // User role
              Text(ap.userModel.role,
                style: const TextStyle(fontSize: 18),
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
                  "Profili Düzenle",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddFlatScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(210, 40),
                ),
                child: const Text(
                  "Daire Ekle",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddFlatScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(210, 40),
                ),
                child: const Text(
                  "Daire Değiştir",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Yardım',
        backgroundColor: Colors.teal,
        child: const Icon(Icons.question_mark,
          color: Colors.white,
        ),
      ),
    );
  }

  editProfileButton({required Null Function() onPressed}) {}


}