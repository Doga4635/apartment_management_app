import 'package:apartment_management_app/models/message_model.dart';
import 'package:apartment_management_app/models/user_model.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_supplier.dart';
class AnnoucementScreen extends StatefulWidget {
  const AnnoucementScreen({Key? key}) : super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnoucementScreen> {
  final List<MessageModel> _messages = [];
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duyuru'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.role),
                    trailing: Text(message.createdAt.toString()),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Mesajınız',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir mesaj girin.';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user = FirebaseAuth.instance.currentUser;
                      final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
                      final userData = await userDoc.get();
                      final userModel = UserModel.fromMap(userData.data()!);
                      if (userModel.role == 'Apartman Yöneticisi') {
                        setState(() {
                          _messages.add(
                            MessageModel(
                              uid: user.uid,
                              content: _controller.text,
                              createdAt: DateTime.now(),
                              role: userModel.role,
                            ),
                          );
                          _controller.clear();
                        });
                      } else {
                        showSnackBar('Sadece Apartman Yöneticisi rolünde mesaj gönderme özelliği sağlanmaktadır.');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}