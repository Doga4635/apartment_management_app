import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPaymentScreenAdmin extends StatefulWidget {
  const UserPaymentScreenAdmin({Key? key}) : super(key: key);

  @override
  _UserPaymentScreenStateAdmin createState() => _UserPaymentScreenStateAdmin();
}

class _UserPaymentScreenStateAdmin extends State<UserPaymentScreenAdmin> {
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _paymentType;
  int? _amountDue;

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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Edit Payment'),
                                content: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        initialValue: paymentType,
                                        decoration: const InputDecoration(hintText: 'Enter Payment Type'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a payment type';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => _paymentType = value,
                                      ),
                                      TextFormField(
                                        initialValue: amountDue.toString(),
                                        decoration: const InputDecoration(hintText: 'Enter Amount Due'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an amount due';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => _amountDue = int.tryParse(value!),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        final querySnapshot = await _firestore.collection('deneme').where('userName', isEqualTo: _userName).get();
                                        if (querySnapshot.docs.isNotEmpty) {
                                          querySnapshot.docs.first.reference.update({
                                            'payments': FieldValue.arrayRemove([
                                              {
                                                'paymentType': paymentData['paymentType'],
                                                'amountDue': paymentData['amountDue'],
                                              }
                                            ]),
                                            'payments': FieldValue.arrayUnion([
                                              {
                                                'paymentType': _paymentType,
                                                'amountDue': _amountDue,
                                              }
                                            ]),
                                          });
                                        }
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Save'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Payment'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Enter User Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a user name';
                          }
                          return null;
                        },
                        onSaved: (value) => _userName = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Enter Payment Type'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a payment type';
                          }
                          return null;
                        },
                        onSaved: (value) => _paymentType = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Enter Amount Due'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount due';
                          }
                          return null;
                        },
                        onSaved: (value) => _amountDue = int.tryParse(value!),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final querySnapshot = await _firestore.collection('deneme').where('userName', isEqualTo: _userName).get();
                        if (querySnapshot.docs.isEmpty) {
                          _firestore.collection('deneme').add({
                            'userName': _userName,
                            'payments': [
                              {
                                'paymentType': _paymentType,
                                'amountDue': _amountDue,
                              }
                            ],
                          });
                        } else {
                          querySnapshot.docs.first.reference.update({
                            'payments': FieldValue.arrayUnion([
                              {
                                'paymentType': _paymentType,
                                'amountDue': _amountDue,
                              }
                            ]),
                          });
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}