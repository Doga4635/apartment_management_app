import 'package:apartment_management_app/screens/first_module_screen.dart';
import 'package:apartment_management_app/screens/new_order_screen.dart';
import 'package:apartment_management_app/screens/order_view_screen.dart';
import 'package:apartment_management_app/screens/permission_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
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
import 'multiple_flat_user_profile_screen.dart';


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
  bool _isLoading = true;
  double? balance = 0;



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
  final List<String> _normalDays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];


  @override
  void initState() {
    super.initState();

    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    Future.wait([
      getCurrentUserListDays(currentUserUid, listDays),
      getCurrentUserListDaysOneTime(currentUserUid, listDayOneTime),
      getCurrentUserListDaysMonday(currentUserUid, listDayMonday),
      getCurrentUserListDaysTuesday(currentUserUid, listDayTuesday),
      getCurrentUserListDaysWednesday(currentUserUid, listDayWednesday),
      getCurrentUserListDaysThursday(currentUserUid, listDayThursday),
      getCurrentUserListDaysFriday(currentUserUid, listDayFriday),
      getCurrentUserListDaysSaturday(currentUserUid, listDaySaturday),
      getCurrentUserListDaysSunday(currentUserUid, listDaySunday),
      getCurrentUserListNames(currentUserUid, listNameList),
    ]).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listeler'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstModuleScreen()));
          },
        ),
        actions: [
          FutureBuilder(
              future: getRoleForFlat(ap.userModel.uid), // Assuming 'role' is the field that contains the user's role
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: Colors.teal,
                  ));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String userRole = snapshot.data ?? '';
                  return userRole == 'Apartman Yöneticisi' ? IconButton(
                    onPressed: () async {
                      String? apartmentName = await getApartmentIdForUser(ap.userModel.uid);

                      //Checking if the user has more than 1 role
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('flats')
                          .where('apartmentId', isEqualTo: apartmentName)
                          .where('isAllowed', isEqualTo: false)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const PermissionScreen()),
                        );
                      } else {
                        showSnackBar(
                            'Kayıt olmak için izin isteyen kullanıcı bulunmamaktadır.');
                      }
                    },
                    icon: const Icon(Icons.verified_user),
                  ) : const SizedBox(width: 2,height: 2);
                }
              }
          ),
          IconButton(
            onPressed: () async {
              String currentUserUid = ap.userModel.uid;

              //Checking if the user has more than 1 role
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('flats')
                  .where('uid', isEqualTo: currentUserUid)
                  .get();

              if (querySnapshot.docs.length > 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MultipleFlatUserProfileScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),

                );
              }
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              ap.userSignOut().then((value) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              ));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),

      body: _isLoading ? const Center(child: CircularProgressIndicator(
        color: Colors.teal,
      )) : Center(
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
                    border: Border.all(color: Colors.teal, width: 1.0),
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
            const Text('Bütçeniz: ',style: TextStyle(fontSize: 20.0),),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text('${balance?.abs()}',
                style: TextStyle(
                  color: balance!.isNegative ? Colors.red: Colors.teal,
                  fontSize: 20.0,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const YardimScreen()),
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
              onPressed: () async {
                // Get the updated values from the text fields
                String name = nameController.text;
                List<String> days = _selectedDays;

                // Close the dialog
                Navigator.of(context).pop();

                // Create the list
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
    String? flatId = await getFlatIdForUser(ap.userModel.uid);

    String apartmentId = '';
    String floorNo = '';
    String flatNo = '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          apartmentId = data['apartmentId'];
          floorNo = data['floorNo'];
          flatNo = data['flatNo'];

        }
      }
    }

    ListModel listModel = ListModel(
      listId: randomListId,
      flatId: flatId!,
      name: name,
      uid: ap.userModel.uid,
      days: days, orders: [],
    );
    ap.saveListDataToFirebase(
      context: context,
      listModel: listModel,
      onSuccess: () {
        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NewOrderScreen(listId:randomListId, days: days, flatId: flatId, apartmentId: apartmentId, floorNo: floorNo, flatNo: flatNo,)),
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
          onSelectionChanged: (value) {
            setState(() {
              if(value.contains('Her gün')) {
                value.clear();
                value.addAll(_normalDays);
              }
              else if(value.contains('Bir kez')) {
                value.clear();
                value.add('Bir kez');
              }
            });},
        );
      },
    );

    setState(() {
      _selectedDays = selectedValues;
    });
  }

  Future<String?> getCurrentUserListNames(String currentUserUid, List<String> listNameList) async {

    String? flatId = await getFlatIdForUser(currentUserUid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listNameList.add(listName);
          }

        }
      }
    } else {
      print('No documents found for the current user.');
    }
    return null;
  }

  Future<List<String>> getCurrentUserListDays(String currentUserUid, List<String> filteredDays) async {
    String? flatId = await getFlatIdForUser(currentUserUid);
    balance = await getBalanceForSelectedFlat(currentUserUid);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('flatId', isEqualTo: flatId)
        .get();
    List<String> listDays = [];
    List<String> orderedDays = [
      'Bir kez','Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
    ];

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
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
      }
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
    String? flatId = await getFlatIdForUser(currentUserUid);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Bir kez')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayOneTime.add(listName);
          }

        }
      }
      print('Bir kez: ');
      print(listDayOneTime);
    } else {
      print('Bir kez: No documents found for the current user.');
    }
    return null;
  }

  Future<String?> getCurrentUserListDaysMonday(String currentUserUid, List<String> listDayMonday) async {
    String? flatId = await getFlatIdForUser(currentUserUid);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Pazartesi')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayMonday.add(listName);
          }

        }
      }
      print('Pzt: ');
      print(listDayMonday);
    } else {
      print('Pzt: No documents found for the current user.');
    }
    return null;
  }

  Future<String?> getCurrentUserListDaysTuesday(String currentUserUid, List<String> listDayTuesday) async {
    String? flatId = await getFlatIdForUser(currentUserUid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Salı')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayTuesday.add(listName);
          }

        }
      }
      print('Salı: ');
      print(listDayTuesday);
    } else {
      print('Salı: No documents found for the current user.');
    }
    return null;
  }

  Future<String?> getCurrentUserListDaysWednesday(String currentUserUid, List<String> listDayWednesday) async {
    String? flatId = await getFlatIdForUser(currentUserUid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Çarşamba')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayWednesday.add(listName);
          }

        }
      }
      print('Çarş: ');
      print(listDayWednesday);
    } else {
      print('Çarş: No documents found for the current user.');
    }
    return null;
  }

  Future<String?> getCurrentUserListDaysThursday(String currentUserUid, List<String> listDayThursday) async {
    String? flatId = await getFlatIdForUser(currentUserUid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Perşembe')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayThursday.add(listName);
          }

        }
      }
      print('Perş: ');
      print(listDayThursday);
    } else {
      print('Perş: No documents found for the current user.');
    }
    return null;
  }

  Future<String?> getCurrentUserListDaysFriday(String currentUserUid, List<String> listDayFriday) async {
    String? flatId = await getFlatIdForUser(currentUserUid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Cuma')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDayFriday.add(listName);
          }

        }
      }
      print('Cuma: ');
      print(listDayFriday);
    } else {
      print('Cuma: No documents found for the current user.');
    }
    return null;
  }


  Future<String?> getCurrentUserListDaysSaturday(String currentUserUid, List<String> listDaySaturday) async {
    String? flatId = await getFlatIdForUser(currentUserUid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Cumartesi')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDaySaturday.add(listName);
          }

        }
      }
      print('Cmt: ');
      print(listDaySaturday);
    } else {
      print('Cmt: No documents found for the current user.');
    }
    return null;
  }


  Future<String?> getCurrentUserListDaysSunday(String currentUserUid, List<String> listDaySunday) async {
    String? flatId = await getFlatIdForUser(currentUserUid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: currentUserUid)
        .where('days', arrayContains: 'Pazar')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['name'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if ( listName != null && !selectedFlat) {
            listDaySunday.add(listName);
          }

        }
      }
      print('Pzr: ');
      print(listDaySunday);
    } else {
      print('Pzr: No documents found for the current user.');
    }
    return null;
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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }

                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Bir kez');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            print('Element "Bir kez" deleted successfully');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }
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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }
                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Pazartesi');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            print('Element "Pazartesi" deleted successfully');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }
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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }
                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Salı');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            print('Element "Salı" deleted successfully');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }

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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }
                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Çarşamba');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            print('Element "Çarşamba" deleted successfully');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }
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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }
                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Perşembe');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            print('Element "Perşembe" deleted successfully');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }

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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }
                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Cuma');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            showSnackBar('Cuma günü başarılı bir şekilde silindi.');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }

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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }
                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Cumartesi');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            print('Element "Cumartesi" deleted successfully');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }
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
                      key: Key('button_$i'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[50],
                        minimumSize: const Size(250, 85),
                      ),
                      onPressed: () async {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var listId = doc.id; // Get the listId from the document
                          print(listId);


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderViewScreen(listId: listId),
                            ),
                          );
                        }
                      },
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
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Emin misiniz?"),
                            content: const Text("Bu listeyi silmek istediğinizden emin misiniz?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User doesn't confirm
                                },
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text("Sil"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        String? flatId = await getFlatIdForUser(currentUserUid);
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('lists')
                            .where('uid', isEqualTo: currentUserUid)
                            .where('name', isEqualTo: dayList[i])
                            .where('flatId', isEqualTo: flatId)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          var doc = querySnapshot.docs.first;
                          var docId = doc.id;
                          var data = doc.data() as Map<String, dynamic>?;
                          if (data != null && data.containsKey('days')) {
                            var days = data['days'] as List<dynamic>;
                            days.remove('Pazar');

                            if (days.isEmpty) {
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('orders')
                                  .where('listId', isEqualTo: docId)
                                  .where('flatId', isEqualTo: flatId)
                                  .get();

                              List<DocumentSnapshot> documents = querySnapshot.docs;

                              for (DocumentSnapshot document in documents) {
                                String orderId = document.id;

                                // Delete the document
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderId)
                                    .delete();
                              }
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
                                builder: (context) => const GroceryListScreen(),
                              ),
                            );
                            print('Element "Pazar" deleted successfully');
                          } else {
                            print('Document data is null or "days" not found');
                          }
                        } else {
                          print('Document not found');
                        }

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
      String? flatId = await getFlatIdForUser(currentUserUid);
      await FirebaseFirestore.instance
          .collection('lists')
          .where('uid', isEqualTo: currentUserUid)
          .where('name', isEqualTo: documentName)
          .where('flatId', isEqualTo: flatId)
          .get();

      print('Document $documentName deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }



}


