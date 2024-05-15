import 'package:apartment_management_app/screens/flat_details_screen.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen({Key? key}) : super(key: key);

  @override
  _UserPaymentScreenState createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
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

    ///TO DO
    ///final user = FirebaseAuth.instance.currentUser;
    ///final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    ///final userData = userDoc.get();
    ///final userModel = UserModel.fromMap(userData.data()!);



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
                .where((payment) => !payment.paid
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
                'Toplam Apartman Borcu: ${totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
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
                      subtitle: Text('Toplam Borç: ${balance.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navigate to a separate screen to show the details of payments for the selected flat ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlatDetailsScreen(selectedFlatNo: flatNo),
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
                .where((payment) => !payment.paid
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
                'Toplam Apartman Borcu: ${totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
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
                      subtitle: Text('Toplam Borç: ${balance.toStringAsFixed(2)}'),
                      onTap: () {
                        // Navigate to a separate screen to show the details of payments for the selected flat ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlatDetailsScreen(selectedFlatNo: flatNo),
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
