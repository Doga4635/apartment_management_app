import 'package:apartment_management_app/models/apartment_model.dart';
import 'package:apartment_management_app/screens/add_flat_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CreateApartmentScreen extends StatefulWidget {
  const CreateApartmentScreen({super.key});

  @override
  CreateApartmentScreenState createState() => CreateApartmentScreenState();
}

class CreateApartmentScreenState extends State<CreateApartmentScreen> {

  @override
  void initState() {
    super.initState();
    getApartments();
  }

  String randomApartmentId = "";
  List<String> _apartmentList = [];



  final nameController = TextEditingController();
  final floorCountController = TextEditingController();
  final flatCountController = TextEditingController();
  final managerCountController = TextEditingController();
  final doormanCountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    floorCountController.dispose();
    flatCountController.dispose();
    managerCountController.dispose();
    doormanCountController.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthSupplier>(context,listen: true).isLoading;
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Apartman Oluştur',style: TextStyle(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.apartment,
                          size: 60.0,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 28.0,top: 8.0,right: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Apartmanın Adını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Apartmanın Adı Nedir?',
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
                  TextField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Apartman Adı',
                    ),
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.home_work,
                          size: 60.0,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0,top: 8.0,right: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Kat Sayısını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Apartmanın kaç katı var?',
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
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: floorCountController,
                    decoration: const InputDecoration(
                      hintText: 'Kat Sayısı',
                    ),
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
                        padding: EdgeInsets.only(left: 20.0,top: 8.0,right: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Daire Sayısını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Apartmanın kaç dairesi var?',
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
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: flatCountController,
                    decoration: const InputDecoration(
                      hintText: 'Daire Sayısı',
                    ),
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.person,
                          size: 60.0,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,top: 8.0,right: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Yönetici Sayısını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Apartmanda kaç yönetici var?',
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
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: managerCountController,
                    decoration: const InputDecoration(
                      hintText: 'Yönetici Sayısı',
                    ),
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.person,
                          size: 60.0,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0,top: 8.0,right: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Kapıcı Sayısını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Apartmanda kaç kapıcı var?',
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
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: doormanCountController,
                    decoration: const InputDecoration(
                      hintText: 'Kapıcı Sayısı',
                    ),
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
      ),
    );
  }

  void storeData() async {

    final ap = Provider.of<AuthSupplier>(context, listen: false);
    randomApartmentId = generateRandomId(10);

    ApartmentModel apartmentModel = ApartmentModel(
      id: randomApartmentId,
      name: nameController.text.trim(),
      floorCount: int.parse(floorCountController.text.trim()),
      flatCount: int.parse(flatCountController.text.trim()),
      managerCount: int.parse(managerCountController.text.trim()),
      doormanCount: int.parse(doormanCountController.text.trim()),
    );

    if (nameController.text.trim() == "Ad") {
      showSnackBar("Lütfen adınızı giriniz.");
    } else if (floorCountController.text.trim() == 'Kat Sayısı') {
      showSnackBar("Lütfen apartman kat sayısını giriniz.");
    } else if (flatCountController.text.trim() == 'Daire Sayısı') {
      showSnackBar("Lütfen apartman daire sayısını giriniz.");
    } else if(managerCountController.text.trim() == 'Yönetici Sayısı') {
      showSnackBar("Lütfen apartman yönetici sayısını giriniz.");
    } else if(doormanCountController.text.trim() == 'Kapıcı Sayısı') {
      showSnackBar("Lütfen apartman kapıcı sayısını giriniz.");
    } else {
      if(_apartmentList.contains(nameController.text.trim())) {
        showSnackBar("Bu isimdeki apartman daha önce uygulamaya kayıt oldu.");
      }
      else {
        ap.saveApartmentDataToFirebase(
          context: context,
          apartmentModel: apartmentModel,
          onSuccess: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFlatScreen()),
            );
          },
        );
      }
    }
  }


}





