import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:apartment_management_app/models/payment_model.dart';
import 'package:apartment_management_app/screens/apartment_payment_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';

class DefinePaymentScreen extends StatefulWidget {
  const DefinePaymentScreen({Key? key}) : super(key: key);

  @override
  DefinePaymentScreenState createState() => DefinePaymentScreenState();
}

class DefinePaymentScreenState extends State<DefinePaymentScreen> {
  String randomPaymentId = "";
  String selectedPaymentName = '';
  String selectedPrice = '';
  String selectedDescription = '';
  String selectedFlat = '';
  String? currentUserApartmentId;
  List<String> _selectedFlats = [];
  List<String> displayedFlats = ['Tüm Daireler'];
  List<String> flats = [];
  DateTime? _selectedDate;
  String? dueDate;


  final paymentNameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final flatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFlats();
  }

  @override
  void dispose() {
    super.dispose();
    paymentNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    flatController.dispose();
  }

  void getFlats() async {
    currentUserApartmentId = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('apartmentId', isEqualTo: currentUserApartmentId)
        .where('role', isEqualTo: 'Apartman Sakini')
        .get();

    if (flatSnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot flat in flatSnapshot.docs) {
        flats.add(flat['flatNo']); // Assuming 'flatNo' is the field containing flat numbers
        displayedFlats.add(flat['flatNo']);

        if (displayedFlats.length > 1) {
          // Extract the first element
          var firstElement = displayedFlats[0];

          // Sort the rest of the list
          var remainingElements = displayedFlats.sublist(1);
          remainingElements.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    // Combine the first element with the sorted remaining elements
    displayedFlats = [firstElement, ...remainingElements];
  }
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthSupplier>(context, listen: true).isLoading;
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ödeme Tanımla',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(FontAwesomeIcons.angleLeft),
          ),
        ),
        body: SafeArea(
          child: isLoading == true
              ? const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          )
              : SingleChildScrollView(
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
                          Icons.wallet,
                          size: 60.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 28.0),
                        child: Column(
                          children: [
                            Text(
                              "Ödeme İsmini Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Ödeme için isim nedir?',
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
                    controller: paymentNameController,
                    decoration: const InputDecoration(
                      labelText: 'Ödeme Adı',
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentName = value;
                      });
                    },
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.attach_money,
                          size: 60.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Column(
                          children: [
                            Text(
                              "Ödeme Miktarını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Ödeme miktarı nedir?',
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
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Ödeme Miktarı',
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedPrice = value;
                      });
                    },
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.description,
                          size: 60.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Column(
                          children: [
                            Text(
                              "Ödeme Açıklamasını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Ödeme için açıklama nedir?',
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
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Açıklama Adı',
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedDescription = value;
                      });
                    },
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.home_filled,
                          size: 60.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24.0,top:10.0),
                        child: Column(
                          children: [
                            Text(
                              "Daire Numarasını Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Ödeme hangi dairelere\ngönderilecek?',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () {
                        _showMultiSelect(context);
                      },
                      child: Text('Daireleri Seçiniz',
                        style: const TextStyle(
                          color: Colors.teal,
                        ),),
                    ),
                  ),

                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.date_range,
                          size: 60.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24.0,top:10.0),
                        child: Column(
                          children: [
                            Text(
                              "Son Tarihi Giriniz",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Ödemenin son tarihi nedir?',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          Text(
            dueDate == null
                ? ''
                : 'Seçili Tarih: $dueDate',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
              onPressed: () => _selectDate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(400, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            'Son Tarihi Seçiniz',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {setState(() {
                        String flatNumber = flatController.text.trim(); // Get the text from the text field and remove leading/trailing spaces
                        if (flatNumber.isNotEmpty) {
                          flatController.clear(); // Clear the text field after adding the flat number
                        }
                        storeData(context);
                      });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70.0, vertical: 15.0),
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
          child: const Icon(
            Icons.question_mark,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      helpText: 'Tarih Seçiniz',
      cancelText: 'İptal Et',
      confirmText: 'Kaydet',
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dueDate = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }


  void storeData(context) async {
    randomPaymentId = generateRandomId(10);
    currentUserApartmentId = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);

    if (selectedPaymentName == '') {
      showSnackBar("Lütfen ödeme adınızı giriniz.");
      return;
    } else if (selectedPrice == '') {
      showSnackBar("Lütfen ödeme miktarını giriniz.");
      return;
    } else if (selectedDescription == '') {
      showSnackBar("Lütfen ödeme açıklamasını giriniz.");
      return;
    } else if (_selectedFlats.isEmpty) {
      showSnackBar("Lütfen daire numarası giriniz.");
      return;
    }
    else if (_selectedDate == null) {
      showSnackBar("Lütfen son tarihi giriniz.");
      return;
    }

    final firestore = FirebaseFirestore.instance;

    try {
      List<String> flatNumbers = _selectedFlats;

      for (String flatNo in flatNumbers) {
        PaymentModel paymentModel = PaymentModel(
          id: randomPaymentId,
          name: selectedPaymentName,
          apartmentId: currentUserApartmentId!,
          description: selectedDescription,
          price: selectedPrice,
          flatNo: flatNo.trim(), // Trim to remove any leading or trailing whitespace
          paid: false,
          dueDate: Timestamp.fromDate(_selectedDate!),
        );

        await firestore.collection('paymentss').doc().set({
          'id' : randomPaymentId,
          'name': paymentModel.name,
          'apartmentId': paymentModel.apartmentId,
          'description': paymentModel.description,
          'price': paymentModel.price,
          'paid': paymentModel.paid,
          'flatNo': flatNo.trim(), // Save the flat number separately
          'dueDate' : paymentModel.dueDate
        });
      }
      showSnackBar("Ödeme başarıyla kaydedildi");
    } catch (error) {
      print(error);
      showSnackBar("Ödeme kaydedilirken bir hata oluştu.");
    }

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ApartmentPaymentScreen()),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    List<String> selectedValues = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: Text('Daireleri Seçiniz'),
          cancelText: Text('Kapat',style: TextStyle(color: Colors.teal),),
          confirmText: Text('Kaydet',style: TextStyle(color: Colors.teal),),
          items: displayedFlats.map((day) {
            return MultiSelectItem<String>(day, day);
          }).toList(),
          initialValue: _selectedFlats,
          selectedColor: Colors.teal,
          onSelectionChanged: (value) {
            setState(() {
              if(value.contains('Tüm Daireler')) {
                value.clear();
                value.addAll(flats);
              }
            });},
        );
      },
    );

    setState(() {
      _selectedFlats = selectedValues;
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }
}