import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:apartment_management_app/models/payment_model.dart';
import 'package:apartment_management_app/screens/apartment_payment_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';

class DefinePaymentScreen extends StatefulWidget {
  const DefinePaymentScreen({Key? key}) : super(key: key);

  @override
  _DefinePaymentScreenState createState() => _DefinePaymentScreenState();
}

class _DefinePaymentScreenState extends State<DefinePaymentScreen> {
  String randomPaymentId = "";

  String selectedPaymentName = '';
  String selectedPrice = '';
  String selectedDescription = '';
  Map<String, bool> selectedFlats = {};

  final paymentNameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final flatController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    paymentNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    flatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthSupplier>(context, listen: true).isLoading;
    return Scaffold(
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
                      padding: EdgeInsets.only(left: 24.0),
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
                  decoration: InputDecoration(
                    hintText: 'Ödeme Adı',
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
                  decoration: InputDecoration(
                    hintText: 'Ödeme Miktarı',
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
                      padding: EdgeInsets.only(left: 24.0),
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
                  decoration: InputDecoration(
                    hintText: 'Açıklama Adı',
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
                      padding: EdgeInsets.only(left: 24.0),
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Daire numarasını giriniz',
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
                const SizedBox(height: 15.0),
                TextField(
                  controller: flatController,
                  decoration: InputDecoration(
                    hintText: 'Daire Numarası',
                    labelText: 'Daire Numarası',
                  ),
                ),
                  ElevatedButton(

                    onPressed: () {
                      setState(() {
                        String flatNumber = flatController.text.trim(); // Get the text from the text field and remove leading/trailing spaces
                        if (flatNumber.isNotEmpty) {
                          selectedFlats[flatNumber] = false; // Add the flat number to the map
                          flatController.clear(); // Clear the text field after adding the flat number
                        }
                      });
                    },
                    child: Text('Add Flat', style: TextStyle(
                      color: Colors.teal,
                    )),
                    // Text for the button
                  ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ElevatedButton(
                    onPressed: () => storeData(),
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
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    randomPaymentId = generateRandomId(10);

    PaymentModel paymentModel = PaymentModel(
      id: randomPaymentId,
      name: selectedPaymentName,
      description: selectedDescription,
      price: selectedPrice,
      flats: selectedFlats,
    );

    if (selectedPaymentName == '') {
      showSnackBar("Lütfen ödeme adınızı giriniz.");
    } else if (selectedPrice == '') {
      showSnackBar("Lütfen ödeme miktarını giriniz.");
    } else if (selectedDescription == '') {
      showSnackBar("Lütfen ödeme açıklamasını giriniz.");
    } else if (selectedFlats.isEmpty) {
      showSnackBar("Lütfen daire numarası giriniz.");
    } else {
      final firestore = FirebaseFirestore.instance;
      try {
        await firestore.collection('payments').doc(randomPaymentId).set({
          'name': paymentModel.name,
          'description': paymentModel.description,
          'price': paymentModel.price,
          'flats': selectedFlats,
        });

        showSnackBar("Ödeme başarıyla kaydedildi.");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ApartmentPaymentScreen()),
        );
      } catch (error) {
        print("Error saving payment data: $error");
        showSnackBar("Ödeme kaydedilirken bir hata oluştu.");
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }
}
