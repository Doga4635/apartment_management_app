import 'package:apartment_management_app/screens/flat_done_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';
import '../utils/utils.dart';
import 'ana_menü_yardım_screen.dart';

class UserPaymentDoneScreen extends StatefulWidget {
  const UserPaymentDoneScreen({Key? key}) : super(key: key);

  @override
  UserPaymentDoneScreenState createState() => UserPaymentDoneScreenState();
}

class UserPaymentDoneScreenState extends State<UserPaymentDoneScreen> {
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
    currentUserFlatNo = await getFlatNoForUser(FirebaseAuth.instance.currentUser!.uid);
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
        : currentUserRole == 'Apartman Yöneticisi' ? Scaffold(
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
              .where((payment) => payment.paid
              && payment.apartmentId == currentUserApartmentId) // Filter out payments where paid is true
              .toList();

          // Map to store total balance per flat ID
          Map<String, double> flatBalances = {};

          // Iterate through payments and accumulate total balance for each flat ID
          double totalBalance = 0.0;
          for (var payment in payments) {
            payment.flatNo.split(',').forEach((flatNo) {
              flatBalances[flatNo.trim()] =
                  (flatBalances[flatNo.trim()] ?? 0.0) + double.parse(payment.price);
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
                    String flatNo = sortedKeys[index];
                    double balance = flatBalances[flatNo] ?? 0.0;

                    return ListTile(
                      title: Text('Daire Numarası: $flatNo'),
                      subtitle: Text('Toplam Ödenen: ${balance.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navigate to a separate screen to show the details of payments for the selected flat ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlatDoneDetailsScreen(selectedFlatNo: flatNo),
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
    ) :
    Scaffold(
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
              .where((payment) => payment.paid
              && payment.flatNo == currentUserFlatNo
              && payment.apartmentId == currentUserApartmentId // Filter out payments where paid is true
          ) // Filter out payments where paid is true
              .toList();

          // Map to store total balance per flat ID
          Map<String, double> flatBalances = {};

          // Iterate through payments and accumulate total balance for each flat ID
          double totalBalance = 0.0;
          for (var payment in payments) {
            payment.flatNo.split(',').forEach((flatNo) {
              flatBalances[flatNo.trim()] =
                  (flatBalances[flatNo.trim()] ?? 0.0) + double.parse(payment.price);
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
                'Toplam Ödenen Tutar: ${totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String flatNo = sortedKeys[index];
                    double balance = flatBalances[flatNo] ?? 0.0;

                    return ListTile(
                      title: Text('Daire Numarası: $flatNo'),
                      subtitle: Text('Toplam Ödenen: ${balance.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navigate to a separate screen to show the details of payments for the selected flat ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlatDoneDetailsScreen(selectedFlatNo: flatNo),
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

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const YardimScreen()),
            );},
            tooltip: 'Yardım',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.question_mark,
              color: Colors.white,
            ),
          ),
        ],

      ),
    );
  }
}