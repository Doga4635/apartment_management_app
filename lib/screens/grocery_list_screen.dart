import 'package:apartment_management_app/screens/first_module_screen.dart';
import 'package:apartment_management_app/screens/new_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import '../models/list_model.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'ana_menü_yardım_screen.dart';


class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});


  @override
  GroceryListScreenState createState() => GroceryListScreenState();
}


class GroceryListScreenState extends State<GroceryListScreen> {

  List<String> listNameList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String randomListId = generateRandomId(10);
  List<String> _selectedDays = [];
  final List<String> _days = [
    'Bir kez',
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
    'Her gün'
  ];


  @override
  void initState() {
    super.initState();

    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    getCurrentUserListNames(currentUserUid ,listNameList).then((_) {
      setState(() {});

    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lists'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstModuleScreen()));
          },
        ),
      ),


      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child:Container(
                  width: 350.0,
                  height: 330.0,


                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),

                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: listNameList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[50],
                            minimumSize: const Size(250, 85),
                          ),
                          onPressed: () async {

                          },
                          child: Text(
                            listNameList[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),



                ), ),

              const SizedBox(height: 30.0),

              ElevatedButton(
                onPressed: () {
                  _showListDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(75, 50),
                ),
                child: const Text(
                  "Liste Oluştur",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

            ],
          ),
        ),

      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YardimScreen()),
                );
              },
              tooltip: 'Yardım',
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.question_mark,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),





    );
  }

  void _showListDialog(BuildContext context) {
    final TextEditingController nameController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Liste Oluştur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'İsim'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _showMultiSelect(context);
                },
                child: Text(_selectedDays.isEmpty ? "Zaman Seçiniz" : _selectedDays.join(", "),
                  style: const TextStyle(
                    color: Colors.teal,
                  ),),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Get the updated values from the text fields
                String name = nameController.text;
                List<String> days = _selectedDays;

                // Close the dialog
                Navigator.of(context).pop();

                createList(name, days);
              },
              child: const Text('Oluştur',style: TextStyle(color: Colors.teal),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal',style: TextStyle(color: Colors.teal),),
            ),
          ],
        );
      },
    );
  }

  void createList(String name, List<String> days) async {


    final ap = Provider.of<AuthSupplier>(context, listen: false);



    ListModel listModel = ListModel(
      listId: randomListId,
      name: name,
      uid: ap.userModel.uid,
      days: days,
    );
    ap.saveListDataToFirebase(
      context: context,
      listModel: listModel,
      onSuccess: () {
        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NewOrderScreen(listId:randomListId, days: days,)),
                (route) => false,
          );
        });


      },
    );
  }

  void _showMultiSelect(BuildContext context) async {
    List<String> selectedValues = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: _days.map((day) {
            return MultiSelectItem<String>(day, day);
          }).toList(),
          initialValue: _selectedDays,
          selectedColor: Colors.teal,
        );
      },
    );

    setState(() {
      _selectedDays = selectedValues;
    });
  }

  Future<String?> getCurrentUserListNames(String currentUserUid, List<String> listNameList) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listNameList.add(listName);
          }

        }
      });
    } else {
      print('No documents found for the current user.');
    }
  }

}