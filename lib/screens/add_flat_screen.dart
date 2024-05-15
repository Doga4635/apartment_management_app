import 'package:apartment_management_app/models/flat_model.dart';
import 'package:apartment_management_app/screens/multiple_flat_user_profile_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/apartment_model.dart';
import 'create_apartment_screen.dart';

class AddFlatScreen extends StatefulWidget {
  const AddFlatScreen({super.key});

  @override
  AddFlatScreenState createState() => AddFlatScreenState();
}

class AddFlatScreenState extends State<AddFlatScreen> {


  @override
  void initState() {
    super.initState();
    getApartments();
  }

  final List<String> _roleList = [
    'Apartman Sakini',
    'Kapıcı',
    'Apartman Yöneticisi',
  ];

  List<String> _apartmentList = [];
  final List<int> _floorList = [];
  final List<int> _flatList = [];

  bool _isLoading = true;


  String randomFlatId = "";

  String selectedRoleValue = 'Rol';
  String selectedApartmentName = 'Apartman Adı';
  int selectedFloorNumber = 0;
  int selectedFlatNumber = 0;

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
                Row(
                  children: [
                    selectedRoleValue =='Apartman Yöneticisi' ?
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateApartmentScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        child: const Icon(Icons.add,color: Colors.white,),
                      ),
                    ):
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Icon(Icons.add,color: Colors.white,),
                      ),
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Expanded(
                      flex: 4,
                      child: CustomDropdown<String>.search(
                        hintText: selectedApartmentName,
                        items: _apartmentList,
                        excludeSelected: false,
                        onChanged: (value) {
                          setState(() {
                            _isLoading = true;
                            selectedApartmentName = value;
                            updateFloorAndFlatLists(selectedApartmentName);
                          });
                        },
                      ),
                    ),
                  ],
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
                selectedApartmentName != 'Apartman Adı' && _isLoading == false ?
                CustomDropdown<int>.search(
                  hintText: 'Kat Numarası',
                  items: _floorList,
                  excludeSelected: false,
                  onChanged: (value) {
                    selectedFloorNumber = value;
                  },
                ) :
                Container(
                  padding: const  EdgeInsets.only(left: 24.0,top: 5.0,right: 24.0,bottom: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Text('Öncelikle apartmanı seçmelisiniz',
                    style: TextStyle(color: Colors.white),
                  ),),
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
                selectedApartmentName != 'Apartman Adı' && _isLoading == false ?
                CustomDropdown<int>.search(
                  hintText: 'Daire Numarası',
                  items: _flatList,
                  excludeSelected: false,
                  onChanged: (value) {
                    selectedFlatNumber = value;
                  },
                ) :
                Container(
                  padding: const  EdgeInsets.only(left: 24.0,top: 5.0,right: 24.0,bottom: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Text('Öncelikle apartmanı seçmelisiniz',
                    style: TextStyle(color: Colors.white),
                  ),),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,top: 18.0,right: 8.0,bottom: 8.0),
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

  void getApartments() async {
    QuerySnapshot productSnapshot =
    await FirebaseFirestore.instance.collection('apartments').get();
    List<ApartmentModel> apartments = productSnapshot.docs.map((doc) {
      return ApartmentModel(
        id: doc['id'] ?? '',
        name: doc['name'] ?? '',
        floorCount: doc['floorCount'] ?? '',
        flatCount: doc['flatCount'] ?? 0,
        managerCount: doc['managerCount'] ?? '',
        doormanCount: doc['doormanCount'] ?? '',
      );
    }).toList();
    _apartmentList = apartments.map((apartment) => apartment.name).toList();
    setState(() {
      _isLoading = false;
    });
  }

  void updateFloorAndFlatLists(String selectedApartment) async {
    setState(() {
      // Clear floor and flat lists
      _floorList.clear();
      _flatList.clear();
      selectedFloorNumber = 0;
      selectedFlatNumber = 0;
    });

    QuerySnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('apartments')
        .where('name', isEqualTo: selectedApartment)
        .get();

    if (productSnapshot.docs.isNotEmpty) {
      // Get the first document
      var doc = productSnapshot.docs.first;

      ApartmentModel apartment = ApartmentModel(
        id: doc.id,
        name: doc['name'],
        floorCount: doc['floorCount'],
        flatCount: doc['flatCount'],
        managerCount: doc['managerCount'],
        doormanCount: doc['doormanCount'],
      );
      int floorNo = apartment.floorCount;
      int flatNo = apartment.flatCount;
      for (int i = 1; i <= floorNo; i++) {
        _floorList.add(i);
      }
      for (int j = 1; j <= flatNo; j++) {
        _flatList.add(j);
      }
    }

    setState(() {
      // Set loading state to false after fetching data
      _isLoading = false;
    });
  }

  void storeData() async {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    randomFlatId = generateRandomId(10);

    String currentUserUid = ap.userModel.uid;

    FlatModel flatModel = FlatModel(
      uid: currentUserUid,
      flatId: randomFlatId,
      apartmentId: selectedApartmentName,
      floorNo: selectedFloorNumber.toString(),
      flatNo: selectedFlatNumber.toString(),
      role: selectedRoleValue,
      garbage: false,
      selectedFlat: false,
      isAllowed: selectedRoleValue == 'Apartman Yöneticisi' ? true : false,
      balance: 0,
    );

      if (selectedRoleValue == "Rol") {
        showSnackBar("Lütfen rolünüzü seçiniz.");
      } else if (selectedApartmentName == 'Apartman Adı') {
        showSnackBar("Lütfen apartman adınızı seçiniz.");
      } else if (selectedApartmentName == 'Flat Number') {
        showSnackBar("Lütfen daire numaranızı seçiniz.");
      } else {
        DocumentSnapshot apartmentDoc = await FirebaseFirestore.instance
            .collection('apartments')
            .where('name', isEqualTo: selectedApartmentName)
            .get()
            .then((apartmentDoc) => apartmentDoc.docs.first);

        int managerCount = apartmentDoc['managerCount'];
        int doormanCount = apartmentDoc['doormanCount'];

        QuerySnapshot managerSnapshot = await FirebaseFirestore.instance
            .collection('flats')
            .where('apartmentId', isEqualTo: selectedApartmentName)
            .where('role', isEqualTo: 'Apartman Yöneticisi')
            .get();

        int existingManagerCount = managerSnapshot.docs.length;

        QuerySnapshot doormanSnapshot = await FirebaseFirestore.instance
            .collection('flats')
            .where('apartmentId', isEqualTo: selectedApartmentName)
            .where('role', isEqualTo: 'Kapıcı')
            .get();

        int existingDoormanCount = doormanSnapshot.docs.length;

        if (selectedRoleValue == 'Apartman Yöneticisi' && existingManagerCount >= managerCount) {
          showSnackBar('Seçili apartmanda olması gereken yönetici sayısına erişildiği için kayıt gerçekleşmedi.');
          return; // Prevent saving data
        } else if (selectedRoleValue == 'Kapıcı' && existingDoormanCount >= doormanCount) {
          showSnackBar('Seçili apartmanda olması gereken kapıcı sayısına erişildiği için kayıt gerçekleşmedi.');
          return; // Prevent saving data
        }

        // Save data if the count has not been exceeded
        ap.saveFlatDataToFirebase(
          context: context,
          flatModel: flatModel,
          onSuccess: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MultipleFlatUserProfileScreen()),
            );
          },
        );
      }
    }


}