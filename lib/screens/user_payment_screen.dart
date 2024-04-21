import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserPaymentScreen extends StatefulWidget
{
  const UserPaymentScreen({Key? key}) : super(key: key);
  @override _UserPaymentScreenState createState() => _UserPaymentScreenState();

}
class _UserPaymentScreenState extends State<UserPaymentScreen>
{
  final _firestore = FirebaseFirestore.instance;

  @override Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Payments'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('payments').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String,
                dynamic>>> snapshot)
        {
          if (!snapshot.hasData)
          {
            return const Center( child: CircularProgressIndicator(),
            );
          }
          final List<DocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
          return ListView(
            children: documents.map((DocumentSnapshot<Map<String, dynamic>> document)
            {
              final Map<String, dynamic> userData = document.data()!;
              final List<dynamic> payments = userData['flats'];
              final String name = userData['name'];
              final String description = userData['description'];
              final String price = userData['price'];
              print(name+description+price);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(name),
                    subtitle: const Text('Payment Name'),
                  ),
                  ListTile(
                    title: Text(description),
                    subtitle: const Text('Desc Name'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payments.length,
                    itemBuilder: (context, index)
                    {
                      final Map<String, dynamic> paymentData = payments[index] as Map<String, dynamic>;
                      final List<dynamic> flats = paymentData['flats'];

                      return ListTile(
                        title: Text('    $flats'),
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