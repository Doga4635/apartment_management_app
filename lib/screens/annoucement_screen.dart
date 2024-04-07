import 'package:apartment_management_app/models/message_model.dart';
import 'package:apartment_management_app/models/user_model.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_supplier.dart';
import 'package:intl/intl.dart';
class AnnoucementScreen extends StatefulWidget {
  const AnnoucementScreen({Key? key}) : super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnoucementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duyuru'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('messages').orderBy('createdAt', descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Bir hata oluştu: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Yükleniyor...");
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = MessageModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                      return ListTile(
                      title: Text(message.content),
                      subtitle: Text(message.role),
                      trailing: Text(
                        DateFormat('dd/MM/yyyy hh:mm a').format(message.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                    },
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
                    String randomId = generateRandomId(10);
                    if (_formKey.currentState!.validate()) {
                      final user = FirebaseAuth.instance.currentUser;
                      final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
                      final userData = await userDoc.get();
                      final userModel = UserModel.fromMap(userData.data()!);
                      if (userModel.role == 'Apartman Yöneticisi') {
                        setState(() {
                          MessageModel  messageModel =
                            MessageModel(
                              uid: user.uid,
                              content: _controller.text,
                              createdAt: DateTime.now(),
                              role: userModel.role,
                              messageId: randomId,
                            );
                          createMessage(messageModel);
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

  void createMessage(MessageModel messageModel) async {
    final ap = Provider.of<AuthSupplier>(context, listen: false);

    ap.saveMessageDataToFirebase(
      context: context,
      messageModel: messageModel,
      onSuccess: () {
        setState(() {
          showSnackBar('Mesaj oluşturuldu.');
        });
      },
    );
  }
}