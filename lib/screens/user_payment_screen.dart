import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen({Key? key}) : super(key: key);

  @override
  _UserPaymentScreenState createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Payments'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('deneme').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<DocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
          return ListView(
            children: documents.map((DocumentSnapshot<Map<String, dynamic>> document) {
              final Map<String, dynamic> userData = document.data()!;
              final String userName = userData['userName'];
              final List<dynamic> payments = userData['payments'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(userName),
                    subtitle: const Text('User Name'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> paymentData = payments[index] as Map<String, dynamic>;
                      final String paymentType = paymentData['paymentType'];
                      final int amountDue = paymentData['amountDue'];
                      return ListTile(
                        title: Text('$paymentType         $amountDue'),
                        subtitle: const Text('Payment Type'),
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}