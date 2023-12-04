import 'package:apartment_management_app/models/user_model.dart';
import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:provider/provider.dart';

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

   final List<String> _roleList = [
    'Resident',
    'Doorman',
    'Manager',
  ];

  final List<String> _apartmentList = [
    'Cihan Apt.',
    'Yakamoz Apt.',
    'Tufan Bey Apt.',
  ];

  final List<String> _flatNumberList = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  String selectedRoleValue = 'Role';
  String selectedApartmentName = 'Apartment Name';
  String selectedFlatNumber = 'Flat Number';

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
  final isLoading = Provider.of<AuthSupplier>(context,listen: true).isLoading;
  return Scaffold(
    body: SafeArea(
      child: isLoading == true ? const Center(child: CircularProgressIndicator(
        color: Colors.teal,
      )) : Padding(
        padding: const EdgeInsets.only(left: 40.0,right: 50.0),
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.person,
                    size: 80.0,),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Choose your Role",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'What is your role in the apartment?',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomDropdown<String>.search(
                hintText: selectedRoleValue,
                items: _roleList,
                excludeSelected: false,
              onChanged: (value) {
                selectedRoleValue = value;
              },
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.apartment,
                    size: 80.0,),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Column(
                    children: [
                      Text(
                        "Choose the Apartment",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Which one is your apartment?',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomDropdown<String>.search(
              hintText: selectedApartmentName,
              items: _apartmentList,
              excludeSelected: false,
              onChanged: (value) {
                selectedApartmentName = value;
              },
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.home_filled,
                    size: 80.0,),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Column(
                    children: [
                      Text(
                        "Select your Flat Number",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Which one is your flat number?',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomDropdown<String>.search(
              hintText: selectedFlatNumber,
              items: _flatNumberList,
              excludeSelected: false,
              onChanged: (value) {
                selectedFlatNumber = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed:  () => storeData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 70.0,vertical: 15.0),
                ),
                child: const Text(
                  'Continue',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      tooltip: 'Help',
      backgroundColor: Colors.teal,
      child: const Icon(Icons.question_mark),
    ),
  );
}

  void storeData() async {
    final ap = Provider.of<AuthSupplier>(context,listen: false);

    UserModel userModel = UserModel(
        uid: "",
        role: selectedRoleValue,
        apartmentName: selectedApartmentName,
        flatNumber: selectedFlatNumber);

    if(selectedRoleValue == "Role") {
      showSnackBar(context, "Please select a role.");
    }
    else if(selectedApartmentName == 'Apartment Name') {
      showSnackBar(context, "Please select an apartment name.");
    }
    else if(selectedApartmentName == 'Flat Number') {
      showSnackBar(context, "Please select a flat number.");
    }
    else {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                  (value) => ap.setSignIn().then(
                          (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MainScreen(),),
                                      (route) => false),
                  ),
          );
        },
      );
    }

  }


}

