import 'package:apartment_management_app/screens/first_module_screen.dart';
//import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/new_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import '../models/list_model.dart';
import '../models/order_model.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';


class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});


  @override
  GroceryListScreenState createState() => GroceryListScreenState();
}


class GroceryListScreenState extends State<GroceryListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  final TextEditingController nameController =
  TextEditingController();
  final TextEditingController daysController =
  TextEditingController();
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
    _getUser();
  }


  void _getUser() async {
    _user = _auth.currentUser;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

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


      body: _user != null
          ? StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('lists')
            .where('uid', isEqualTo: _user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showListDialog(context);
            });
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              final list = ListModel.fromSnapshot(document);
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('listId', isEqualTo: list.listId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                  if (orderSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (orderSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${orderSnapshot.error}'),
                    );
                  }
                  return Column(
                    children: [
                      ListTile(
                        title: Text(list.name),
                        // Daha fazla detay eklenebilir
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: orderSnapshot.data!.docs.map((orderDocument) {
                          final order = OrderModel(
                            orderId: orderDocument['orderId'],
                            listId: orderDocument['listId'],
                            productId: orderDocument['productId'],
                            name: orderDocument['name'],
                            amount: orderDocument['amount'],
                            details: orderDocument['details'],
                            place: orderDocument['place'],
                            days: orderDocument['days'],
                          );
                          return ListTile(
                            title: Text('${order.name} - Miktar: ${order.amount}'),
                            subtitle: Text('Details: ${order.details} - Yer: ${order.place}'),
                            // Other order details can be displayed here
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          );
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: GestureDetector(
            onTap: () {
              _showListDialog(context);
            },
            child: const Text(
              'Liste Oluştur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
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

}
