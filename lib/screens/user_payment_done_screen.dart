import 'package:apartment_management_app/screens/flat_done_details_screen.dart';
import 'package:apartment_management_app/screens/flat_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/payment_model.dart';
import '../services/auth_supplier.dart';

class UserPaymentDoneScreen extends StatefulWidget {
  const UserPaymentDoneScreen({Key? key}) : super(key: key);

  @override
  _UserPaymentDoneScreenState createState() => _UserPaymentDoneScreenState();
}

class _UserPaymentDoneScreenState extends State<UserPaymentDoneScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    String currentUserFlatNo = ap.userModel.flatNumber;
    print(currentUserFlatNo);



    return Scaffold(
      appBar: AppBar(
        title: const Text('Daire Ödemeleri'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('paymentss').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          List<PaymentModel> payments = snapshot.data!.docs
              .map((doc) => PaymentModel.fromSnapshot(doc))
              .where((payment) => payment.paid && currentUserFlatNo == payment.flatNo) // Filter out payments where paid is true
              .toList();

          // Map to store total balance per flat ID
          Map<String, double> flatBalances = {};

          // Iterate through payments and accumulate total balance for each flat ID
          double totalBalance = 0.0;
          for (var payment in payments) {
            payment.flatNo.split(',').forEach((flatId) {
              flatBalances[flatId.trim()] =
                  (flatBalances[flatId.trim()] ?? 0.0) + double.parse(payment.price);
              totalBalance += double.parse(payment.price);
            });
          }

          // Sort the flatBalances map by keys (apartment numbers) in ascending order
          List<String> sortedKeys = flatBalances.keys.toList()
            ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

          // Build the ListView with sorted keys
          return Column(
            children: [
              Text(
                'Toplam Apartman Ödenen: ${totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String flatId = sortedKeys[index];
                    double balance = flatBalances[flatId] ?? 0.0;

                    return ListTile(
                      title: Text('Daire Numarası: $flatId'),
                      subtitle: Text('Toplam Ödenen: ${balance.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navigate to a separate screen to show the details of payments for the selected flat ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlatDoneDetailsScreen(selectedFlatId: flatId),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}