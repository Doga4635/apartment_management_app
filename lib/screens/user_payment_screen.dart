import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen({Key? key}) : super(key: key);

  @override
  _UserPaymentScreenState createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Payments'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('payments').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final Map<String, dynamic> userData = documents[index].data()!;
              final Map<String, dynamic>? flatId = userData['flatId'] as Map<String, dynamic>?; // Extract flatId
              final String apartmentName = userData['apartmentId'];
              final String name = userData['name'];
              final String description = userData['description'];
              final String price = userData['price'];

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
                    title: Text(price.toString()),
                    subtitle: const Text('Tutar'),
                  ),
                  if (flatId != null) // Check if flatId is not null
                    ListTile(
                      title: Text('Daire No: ${flatId.keys}'), // Display flatId
                      subtitle: Row(
                        children: [
                          Text('Ödeme bilgisi '), // Adjust this based on your flatId structure
                          if (flatId.values.contains(false))
                            Icon(Icons.clear, color: Colors.red), // Show red X if flatId contains false
                        ],
                      ),
                    ),

                  const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
