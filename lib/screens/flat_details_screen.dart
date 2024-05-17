import 'package:apartment_management_app/models/payment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class FlatDetailsScreen extends StatefulWidget {
  const FlatDetailsScreen({Key? key, required this.selectedFlatNo}) : super(key: key);

  final String selectedFlatNo;
  @override
  FlatDetailsScreenState createState() => FlatDetailsScreenState();
}

class FlatDetailsScreenState extends State<FlatDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserFlatNo;
  String? currentUserRole;
  String? currentUserApartmentId;
  bool isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApartmentDetails();

  }
  void getApartmentDetails() async {
    currentUserApartmentId = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);
    currentUserRole = await getRoleForFlat(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return isLoading ? const Center(
      child: CircularProgressIndicator(
        color: Colors.teal,
      ),
    )
        : GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
          child: Scaffold(
                appBar: AppBar(
          title: const Text('Daire Ödemeleri'),
                ),
                body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('paymentss')
              .where('flatNo', isEqualTo: widget.selectedFlatNo)
              .where('paid', isEqualTo: false)
              .where('apartmentId', isEqualTo: currentUserApartmentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            }

            List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data!.docs;

            int totalBalance = 0;
            for (var document in documents) {
              final PaymentModel payment = PaymentModel.fromSnapshot(document);
              totalBalance += int.parse(payment.price);
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Toplam Apartman Borcu: $totalBalance',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final PaymentModel payment = PaymentModel.fromSnapshot(documents[index]);
                      final String apartmentName = payment.apartmentId;
                      final String name = payment.name;
                      final String description = payment.description;
                      final String price = payment.price;

                      return _buildPaymentCard(
                        name: name,
                        apartmentName: apartmentName,
                        description: description,
                        price: price,
                        flatId: widget.selectedFlatNo, onPressed: () { // Add onPressed callback
                        // Update the payment document to set paid to true
                        _firestore.collection('paymentss').doc(payment.id).update(
                          {'paid': true},
                          // and back to the previous screen
                        );
                      },
                      );
                    },
                  ),
                ],
              ),
            );
          },
                ),
              ),
        );
  }

  Widget _buildPaymentCard({
    required String name,
    required String apartmentName,
    required String description,
    required String price,
    required String flatId,
    required VoidCallback onPressed, // Callback to handle button press
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(name),
          subtitle: const Text('Ödeme Türü'),
        ),
        ListTile(
          title: Text(apartmentName),
          subtitle: const Text('Apartman Adı'),
        ),
        ListTile(
          title: Text(description),
          subtitle: const Text('Açıklama'),
        ),
        ListTile(
          title: Text(price),
          subtitle: const Text('Tutar'),
        ),
        ListTile(
          title: Text('Daire No: $flatId'), // Display flatId
          subtitle: currentUserRole == 'Apartman Yöneticisi' ? IconButton( // Add IconButton for setting paid to true
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: onPressed, // Call the onPressed callback
          ) : null,
        ),
        const Divider(),
      ],
    );
  }
}
