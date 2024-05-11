import 'package:apartment_management_app/models/message_model.dart';
import 'package:apartment_management_app/models/poll_model.dart';
import 'package:apartment_management_app/models/user_model.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  AnnouncementScreenState createState() => AnnouncementScreenState();
}

class AnnouncementScreenState extends State<AnnouncementScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return FutureBuilder<String?>(
      future: ap.getField('role'), // Assuming roleStream is a Stream<String>
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String userRole = snapshot.data?? '';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Duyuru'),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildPollsSection(ap, userRole),
                ),
                Expanded(
                  flex: 1,
                  child: _buildMessagesSection(ap, userRole),
                ),
                userRole == 'Apartman Yöneticisi'
                    ? _buildMessageInputSection(ap)
                    : Container(),
                userRole == 'Apartman Yöneticisi'
                    ? _buildPollCreationButton(ap)
                    : Container(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildPollsSection(AuthSupplier ap, String userRole) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('polls')
          .orderBy('createdAt', descending: true)
          .where('apartmentId', isEqualTo: getApartmentIdForUser(ap.userModel.uid))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Bir hata oluştu: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final poll = PollModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
            DateTime createdAt = poll.createdAt.toDate();
            String formattedCreatedAt = DateFormat('dd-MM-yyyy').format(createdAt);
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 24.0, top: 5.0, right: 24.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(poll.title, style: const TextStyle(color: Colors.white),),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {} ,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text(poll.options[0]),
                    ),
                    ElevatedButton(
                        onPressed: () {} ,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text(poll.options[1])
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMessagesSection(AuthSupplier ap, String userRole) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Bir hata oluştu: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final message = MessageModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
            DateTime createdAt = message.createdAt.toDate();
            String formattedCreatedAt = DateFormat('dd-MM-yyyy').format(createdAt);
            return ListTile(
              title: Text(message.content),
              subtitle: Text(message.role),
              trailing: Text(formattedCreatedAt),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInputSection(AuthSupplier ap) {
    return Form(
      key: _formKey1,
      child: Padding(
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
                if (_formKey1.currentState!.validate()) {
                  final user = FirebaseAuth.instance.currentUser;
                  final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
                  final userData = await userDoc.get();
                  final userModel = UserModel.fromMap(userData.data()!);
                  if (userModel.role == 'Apartman Yöneticisi') {
                    final messageModel = MessageModel(
                      uid: user.uid,
                      content: _controller.text,
                      createdAt: Timestamp.now(),
                      role: userModel.role,
                      messageId: generateRandomId(10),
                      apartmentName: userModel.apartmentName,
                    );
                    await createMessage(messageModel);
                    _controller.clear();
                  } else {
                    showSnackBar(
                        'Sadece Apartman Yöneticisi rolünde mesaj gönderme özelliği sağlanmaktadır.');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollCreationButton(AuthSupplier ap) {
    return ElevatedButton(
      onPressed: () async {
        final user = FirebaseAuth.instance.currentUser;
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
        final userData = await userDoc.get();
        final userModel = UserModel.fromMap(userData.data()!);

        if (userModel.role == 'Apartman Yöneticisi') {
          final pollTitleController = TextEditingController();
          final pollOptionsController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Oylama Oluştur'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pollTitleController,
                      decoration: InputDecoration(labelText: 'Oylama Başlığı'),
                    ),
                    TextField(
                      controller: pollOptionsController,
                      decoration: InputDecoration(
                          labelText: 'Oylama Seçenekleri (virgülle ayrılmış)'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      final pollTitle = pollTitleController.text;
                      final pollOptions = pollOptionsController.text.split(',');
                      String? apartmentId = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);

                      if (pollTitle.isNotEmpty && pollOptions.isNotEmpty) {
                        final pollModel = PollModel(
                          id: generateRandomId(10),
                          apartmentId: apartmentId!,
                          title: pollTitle,
                          options: pollOptions,
                          createdAt: Timestamp.now(),
                          updatedAt: Timestamp.now(),
                        );

                        await FirebaseFirestore.instance
                            .collection('polls')
                            .doc(pollModel.id)
                            .set(pollModel.toMap());

                        Navigator.pop(context);
                        showSnackBar('Oylama oluşturuldu.');
                      } else {
                        showSnackBar('Lütfen tüm alanları doldurun.');
                      }
                    },
                    child: Text('Oylama Oluştur'),
                  ),
                ],
              );
            },
          );
        } else {
          showSnackBar(
              'Sadece Apartman Yöneticisi rolünde oylama oluşturma özelliği sağlanmaktadır.');
        }
      },
      child: Text('Oylama Oluştur'),
    );
  }

  Future<void> createMessage(MessageModel messageModel) async {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    await ap.saveMessageDataToFirebase(
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