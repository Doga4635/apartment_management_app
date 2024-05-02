import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../services/auth_supplier.dart';

class UserPaymentScreen extends StatefulWidget {
  const UserPaymentScreen({Key? key}) : super(key: key);

  @override
  _UserPaymentScreenState createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    final ap = Provider.of<AuthSupplier>(context,listen: false);
    String currentUserUid = ap.userModel.uid;
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

              if (flatId!= null && flatId.values.contains(true)) {
                return Container(); // Return an empty container if flatId is true
              }
              getUserFlatNumber(currentUserUid).then((value) {
                print(value);
                print(flatId?.keys);
                if (flatId!.keys.contains(value) != true) {
                  return Container(); // Return an empty container if flatId is not equal to currentUserFlat
                }
              });


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
                  if (flatId!= null) // Check if flatId is not null
                    ListTile(
                      title: Text('Daire No: ${flatId.keys}'), // Display flatId
                      subtitle: Row(
                        children: [
                          Text('Ödeme bilgisi '), // Adjust this based on your flatId structure
                          if (flatId.values.contains(false))
                            Icon(Icons.clear, color: Colors.red),
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
Future<String?> getUserFlatNumber(String currentUserUid) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: currentUserUid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot userDoc = querySnapshot.docs.first;
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    if (userData != null && userData.containsKey('flatNumber')) {
      String flatNumber = userData['flatNumber'] as String;
      return flatNumber;
    } else {
      return null;
    }
  } else {
    return null;
  }
}