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
  List<String> listDays = [];
  List<String> listDayOneTime = [];
  List<String> listDayMonday = [];
  List<String> listDayTuesday = [];
  List<String> listDayWednesday = [];
  List<String> listDayThursday = [];
  List<String> listDayFriday = [];
  List<String> listDaySaturday = [];
  List<String> listDaySunday = [];



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
    getCurrentUserListDays(currentUserUid ,listDays);
    print(listDays);
    getCurrentUserListDaysOneTime(currentUserUid, listDayOneTime);
    getCurrentUserListDaysMonday(currentUserUid, listDayMonday);
    getCurrentUserListDaysTuesday(currentUserUid, listDayTuesday);
    getCurrentUserListDaysWednesday(currentUserUid, listDayWednesday);
    getCurrentUserListDaysThursday(currentUserUid, listDayThursday);
    getCurrentUserListDaysFriday(currentUserUid, listDayFriday);
    getCurrentUserListDaysSaturday(currentUserUid, listDaySaturday);
    getCurrentUserListDaysSunday(currentUserUid, listDaySunday);
    getCurrentUserListNames(currentUserUid ,listNameList).then((_) {
      setState(() {});
    });



  }

  @override
  Widget build(BuildContext context) {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
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
                child: Container(
                  width: 350.0,
                  height: 330.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (listDays.contains('Bir kez'))
                          ...buildDayColumnOneTime('Bir kez', listDayOneTime,currentUserUid ),
                        if (listDays.contains('Pazartesi'))
                          ...buildDayColumnMonday('Pazartesi', listDayMonday,currentUserUid ),
                        if (listDays.contains('Salı'))
                          ...buildDayColumnTuesday('Salı', listDayTuesday,currentUserUid),
                        if (listDays.contains('Çarşamba'))
                          ...buildDayColumnWednesday('Çarşamba', listDayWednesday,currentUserUid),
                        if (listDays.contains('Perşembe'))
                          ...buildDayColumnThursday('Perşembe', listDayThursday,currentUserUid),
                        if (listDays.contains('Cuma'))
                          ...buildDayColumnFriday('Cuma', listDayFriday,currentUserUid),
                        if (listDays.contains('Cumartesi'))
                          ...buildDayColumnSaturday('Cumartesi', listDaySaturday,currentUserUid),
                        if (listDays.contains('Pazar'))
                          ...buildDayColumnSunday('Pazar', listDaySunday,currentUserUid),
                      ],
                    ),
                  ),
                ),
              ),
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

  Future<List<String>> getCurrentUserListDays(String currentUserUid, List<String> filteredDays) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .get();
    List<String> listDays = [];
    List<String> orderedDays = [
      'Bir kez','Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
    ];

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          List<dynamic>? days = data['days'] as List<dynamic>?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if (days != null && !selectedFlat) {
            for (dynamic day in days) {
              String dayString = day.toString();
              if (!listDays.contains(dayString)) {
                listDays.add(dayString);
              }
            }
          }
        }
      });
    } else {
      print('No documents found for the current user.');
    }

    // Filter and order the days according to the specified order
    for (String day in orderedDays) {
      if (listDays.contains(day)) {
        filteredDays.add(day);
      } else {
        filteredDays.add(' ');
      }
    }

    print(filteredDays);
    return filteredDays;
  }

  Future<String?> getCurrentUserListDaysOneTime(String currentUserUid, List<String> listDayOneTime) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Bir kez')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayOneTime.add(listName);
          }

        }
      });
      print('Bir kez: ');
      print(listDayOneTime);
    } else {
      print('Bir kez: No documents found for the current user.');
    }
  }

  Future<String?> getCurrentUserListDaysMonday(String currentUserUid, List<String> listDayMonday) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Pazartesi')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayMonday.add(listName);
          }

        }
      });
      print('Pzt: ');
      print(listDayMonday);
    } else {
      print('Pzt: No documents found for the current user.');
    }
  }

  Future<String?> getCurrentUserListDaysTuesday(String currentUserUid, List<String> listDayTuesday) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Salı')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayTuesday.add(listName);
          }

        }
      });
      print('Salı: ');
      print(listDayTuesday);
    } else {
      print('Salı: No documents found for the current user.');
    }
  }

  Future<String?> getCurrentUserListDaysWednesday(String currentUserUid, List<String> listDayWednesday) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Çarşamba')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayWednesday.add(listName);
          }

        }
      });
      print('Çarş: ');
      print(listDayWednesday);
    } else {
      print('Çarş: No documents found for the current user.');
    }
  }

  Future<String?> getCurrentUserListDaysThursday(String currentUserUid, List<String> listDayThursday) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Perşembe')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayThursday.add(listName);
          }

        }
      });
      print('Perş: ');
      print(listDayThursday);
    } else {
      print('Perş: No documents found for the current user.');
    }
  }

  Future<String?> getCurrentUserListDaysFriday(String currentUserUid, List<String> listDayFriday) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Cuma')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayFriday.add(listName);
          }

        }
      });
      print('Cuma: ');
      print(listDayFriday);
    } else {
      print('Cuma: No documents found for the current user.');
    }
  }


  Future<String?> getCurrentUserListDaysSaturday(String currentUserUid, List<String> listDaySaturday) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Cumartesi')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDaySaturday.add(listName);
          }

        }
      });
      print('Cmt: ');
      print(listDaySaturday);
    } else {
      print('Cmt: No documents found for the current user.');
    }
  }


  Future<String?> getCurrentUserListDaysSunday(String currentUserUid, List<String> listDaySunday) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Pazar')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDaySunday.add(listName);
          }

        }
      });
      print('Pzr: ');
      print(listDaySunday);
    } else {
      print('Pzr: No documents found for the current user.');
    }
  }


  List<Widget> buildDayColumnOneTime(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Bir kez');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});}

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysOneTime(currentUserUid, listDayOneTime);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Bir kez" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> buildDayColumnMonday(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Pazartesi');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});}

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysMonday(currentUserUid, listDayMonday);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Pazartesi" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }


  List<Widget> buildDayColumnTuesday(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Salı');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});}

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysTuesday(currentUserUid, listDayTuesday);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Salı" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }


  List<Widget> buildDayColumnWednesday(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Çarşamba');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});}

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysWednesday(currentUserUid, listDayWednesday);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Çarşamba" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }


  List<Widget> buildDayColumnThursday(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Perşembe');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});}

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysThursday(currentUserUid, listDayThursday);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Perşembe" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> buildDayColumnFriday(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Cuma');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});}

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysFriday(currentUserUid, listDayFriday);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Cuma" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> buildDayColumnSaturday(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Cumartesi');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});}

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysSaturday(currentUserUid, listDaySaturday);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Cumartesi" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> buildDayColumnSunday(String day, List<String> dayList, String currentUserUid) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(day,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          for (int i = 0; i < dayList.length; i++)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {},
                      child: Text(
                        dayList[i],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('lists')
                          .where('uid', isEqualTo: currentUserUid)
                          .where('name', isEqualTo: dayList[i])
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var doc = querySnapshot.docs.first;
                        var docId = doc.id;
                        var data = doc.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('days')) {
                          var days = data['days'] as List<dynamic>;
                          days.remove('Pazar');

                          if (days.isEmpty) {
                            await FirebaseFirestore.instance.collection('lists').doc(docId).delete();
                            print('Document deleted successfully');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('lists')
                                .doc(docId)
                                .update({'days': days});
                          }

                          setState(() {
                            getCurrentUserListDays(currentUserUid ,listDays);
                            print(listDays);
                            getCurrentUserListDaysSunday(currentUserUid, listDaySunday);
                          });

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => GroceryListScreen(),
                            ),
                          );
                          print('Element "Pazar" deleted successfully');
                        } else {
                          print('Document data is null or "days" not found');
                        }
                      } else {
                        print('Document not found');
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ];
  }



  Future<void> deleteDocument(String documentName, String currentUserUid) async {
    try {
      await FirebaseFirestore.instance
          .collection('lists')
          .where('uid', isEqualTo: currentUserUid)
          .where('name', isEqualTo: documentName)
          .get();

      print('Document $documentName deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }



}

