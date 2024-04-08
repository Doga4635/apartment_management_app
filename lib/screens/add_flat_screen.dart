import 'package:apartment_management_app/models/flat_model.dart';
import 'package:apartment_management_app/screens/multiple_flat_user_profile_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddFlatScreen extends StatefulWidget {
  const AddFlatScreen({super.key});

  @override
  AddFlatScreenState createState() => AddFlatScreenState();
}

class AddFlatScreenState extends State<AddFlatScreen> {


  @override
  void initState() {
    super.initState();
  }

  final List<String> _roleList = [
    'Apartman Sakini',
    'Kapıcı',
    'Apartman Yöneticisi',
  ];

  final List<String> _apartmentList = [
    'Cihan Apt.',
    'Yakamoz Apt.',
    'Tufan Bey Apt.',
  ];

  final List<String> _numberList = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  String randomFlatId = "";

  String selectedRoleValue = 'Rol';
  String selectedApartmentName = 'Apartman Adı';
  String selectedFloorNumber = 'Kat Numarası';
  String selectedFlatNumber = 'Daire Numarası';

  final TextEditingController roleController = TextEditingController();
  final apartmentController = TextEditingController();
  final floorNumberController = TextEditingController();
  final flatNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    roleController.dispose();
    apartmentController.dispose();
    floorNumberController.dispose();
    flatNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthSupplier>(context,listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daire Ekle',style: TextStyle(
          fontSize: 28,
        ),
        ),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },
          icon: const Icon(FontAwesomeIcons.angleLeft),
        ),
      ),
      body: SafeArea(
        child: isLoading == true ? const Center(child: CircularProgressIndicator(
          color: Colors.teal,
        )) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 3.0,
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.person_search,
                        size: 60.0,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          Text(
                            "Rolünüzü Seçin",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Dairedeki rolünüz nedir?',
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
                    setState(() {
                      selectedRoleValue = value;
                    });
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.apartment,
                        size: 60.0,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          Text(
                            "Apartmanınızı Seçiniz",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Hangisi sizin apartmanınız?',
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
                    setState(() {
                      selectedApartmentName = value;
                    });
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.home_work,
                        size: 60.0,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          Text(
                            "Kat Numaranızı Seçiniz",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Hangisi sizin kat numaranız?',
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
                  hintText: selectedFloorNumber,
                  items: _numberList,
                  excludeSelected: false,
                  onChanged: (value) {
                    setState(() {
                      selectedFloorNumber = value;
                    });
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.home_filled,
                        size: 60.0,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          Text(
                            "Daire Numaranızı Seçiniz",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Hangisi sizin daire numaranız?',
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
                  items: _numberList,
                  excludeSelected: false,
                  onChanged: (value) {
                    setState(() {
                      selectedFlatNumber = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ElevatedButton(
                    onPressed:  () => storeData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 70.0,vertical: 15.0),
                    ),
                    child: const Text(
                      'Kaydet',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

  void storeData() async {

    final ap = Provider.of<AuthSupplier>(context, listen: false);
    randomFlatId = generateRandomId(10);

    String currentUserUid = ap.userModel.uid;

    FlatModel flatModel = FlatModel(
      uid: currentUserUid,
      flatId: randomFlatId,
      apartmentId: selectedApartmentName,
      floorNo: selectedFloorNumber,
      flatNo: selectedFlatNumber,
      role: selectedRoleValue,
      garbage: false,
      selectedFlat: false,
    );

    if (selectedRoleValue == "Rol") {
      showSnackBar("Lütfen rolünüzü seçiniz.");
    } else if (selectedApartmentName == 'Apartman Adı') {
      showSnackBar("Lütfen apartman adınızı seçiniz.");
    } else if (selectedApartmentName == 'Flat Number') {
      showSnackBar("Lütfen daire numaranızı seçiniz.");
    } else {
      ap.saveFlatDataToFirebase(
        context: context,
        flatModel: flatModel,
        onSuccess: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MultipleFlatUserProfileScreen()),
          );
        },
      );
    }
  }


}