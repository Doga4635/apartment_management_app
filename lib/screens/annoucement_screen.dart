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
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  String? apartmentId;
  bool _isLoading = true;
  int colorIndex = 0;
  int clickIndex = 0;

  List<Color> colors = [
    Colors.green,Colors.red,Colors.blue,Colors.yellow,Colors.deepPurpleAccent,Colors.orange
  ];

  @override
  void initState() {
    super.initState();
    getApartmentId();
    deletePastPolls();
  }

  void getApartmentId() async {
    apartmentId = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _isLoading = false;
    });
  }

  void deletePastPolls() async {
    apartmentId = await getApartmentIdForUser(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot pollSnapshot = await FirebaseFirestore.instance
        .collection('polls')
        .where('apartmentId', isEqualTo: apartmentId)
        .get();

    // Get the current timestamp
    Timestamp now = Timestamp.now();

    // Iterate through the messages
    for (DocumentSnapshot pollDoc in pollSnapshot.docs) {
      Timestamp? finishedAt = pollDoc['finishedAt'];

      print(finishedAt);

      // Check if finishedAt exists and if it's in the past relative to now
      if (finishedAt != null && finishedAt.compareTo(now) < 0) {
        // Delete the message from Firestore
        await FirebaseFirestore.instance
            .collection('polls')
            .doc(pollDoc.id)
            .delete();

        print('Message deleted: ${pollDoc.id}');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return _isLoading ?  const Center(child: CircularProgressIndicator(
      color: Colors.teal,
    )) : FutureBuilder<String?>(
      future: ap.getField('role'), // Assuming roleStream is a Stream<String>
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String userRole = snapshot.data?? '';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Duyurular / Oylamalar'),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildPollsSection(ap, userRole),
                ),
                userRole == 'Apartman Yöneticisi'
                    ? _buildPollCreationButton(ap)
                    : Container(),
                Expanded(
                  flex: 1,
                  child: _buildMessagesSection(userRole),
                ),
                userRole == 'Apartman Yöneticisi'
                    ? _buildMessageInputSection(ap)
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
          .where('apartmentId', isEqualTo: apartmentId)
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
            final poll = PollModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
            colorIndex = 0;
            List<bool> isClicked = List.filled(poll.options.length, false); // Initialize the list of clicked options
            return Column(
              children: [
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16.0, top: 5.0, right: 16.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(poll.title, style: const TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                      ),
                      Row(
                        children: List.generate(poll.options.length, (optionIndex) {
                          // Ensure colorIndex does not exceed the length of colors list
                          colorIndex %= colors.length;
                          return ElevatedButton(
                            onPressed: userRole == 'Apartman Yöneticisi' ? null : isClicked[optionIndex] // Check if the button is already clicked
                                ? null // Disable the button if it's already clicked
                                : () {
                              // If the button is not clicked, update scores and disable the button
                              poll.scores.update(poll.options[optionIndex], (value) => value + 1, ifAbsent: () => 1); // Use the option as the key
                              FirebaseFirestore.instance.collection('polls').doc(poll.id).update({
                                'scores': poll.scores,
                              });
                              setState(() {
                                // Update the list of clicked options
                                isClicked[optionIndex] = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors[colorIndex++],
                              padding: const EdgeInsets.symmetric(horizontal: 36.0), // Adjust padding as needed
                            ),
                            child: Text(userRole=='Apartman Yöneticisi' ? '${poll.options[optionIndex]} : ${poll.scores[poll.options[optionIndex]]}' : poll.options[optionIndex],
                                style: TextStyle(color: userRole == 'Apartman Yöneticisi' ? Colors.black : Colors.white)),
                          );
                        }),
                      ),
                      const SizedBox(height: 16,)
                    ],
                  ),
                ),
              ],
            );
          },
        );



      }
    );
  }

  Widget _buildMessagesSection(String userRole) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('apartmentId', isEqualTo: apartmentId)
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
                      content: _controller.text.trim(),
                      createdAt: Timestamp.now(),
                      role: userModel.role,
                      messageId: generateRandomId(10),
                      apartmentId: userModel.apartmentName,
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
        final userDoc = FirebaseFirestore.instance.collection('users').doc(
            user!.uid);
        final userData = await userDoc.get();
        final userModel = UserModel.fromMap(userData.data()!);

        if (userModel.role == 'Apartman Yöneticisi') {
          final pollTitleController = TextEditingController();
          final pollOptionsController = TextEditingController();
          final pollDaysController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Oylama Oluştur'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pollTitleController,
                      decoration: const InputDecoration(
                          labelText: 'Oylama Başlığı'),
                    ),
                    TextField(
                      controller: pollOptionsController,
                      decoration: const InputDecoration(
                          labelText: 'Seçenekler (, ile ayrı yazın)'),
                    ),
                    TextField(
                      controller: pollDaysController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Oylama kaç gün aktif kalacak?'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      final pollTitle = pollTitleController.text.trim();
                      final pollOptions = pollOptionsController.text.trim().split(',');
                      String? apartmentId = await getApartmentIdForUser(
                          FirebaseAuth.instance.currentUser!.uid);
                      final Timestamp now = Timestamp.now();
                      final int daysInMilliseconds = int.parse(
                          pollDaysController.text.trim()) * 24 * 60 * 60 * 1000;
                      final Timestamp finishedAt = Timestamp
                          .fromMillisecondsSinceEpoch(
                          now.millisecondsSinceEpoch + daysInMilliseconds);


                      Map<String, int> scores = {};
                      for (int i = 0; i < pollOptions.length; i++) {
                        scores[pollOptions[i]] = 0;
                      }

                      if (pollTitle.isNotEmpty && pollOptions.isNotEmpty) {
                        final pollModel = PollModel(
                          id: generateRandomId(10),
                          apartmentId: apartmentId!,
                          title: pollTitle,
                          options: pollOptions,
                          scores: scores,
                          createdAt: Timestamp.now(),
                          finishedAt: finishedAt,
                        );

                        await FirebaseFirestore.instance
                            .collection('polls')
                            .doc(pollModel.id)
                            .set(pollModel.toMap());

                        QuerySnapshot flatSnapshot = await FirebaseFirestore
                            .instance
                            .collection('flats')
                            .where('apartmentId', isEqualTo: apartmentId)
                            .where('role', isNotEqualTo: 'Apartman Yöneticisi')
                            .get();

                        if (flatSnapshot.docs.isNotEmpty) {
                          for (var flat in flatSnapshot.docs) {
                            sendNotificationToResident(
                                flat.id, 'Yönetici bir oylama başlattı.');
                          }
                        }

                        Navigator.pop(context);
                        showSnackBar('Oylama oluşturuldu.');
                      } else {
                        showSnackBar('Lütfen tüm alanları doldurun.');
                      }
                    },
                    child: const Text(
                      'Oylama Oluştur', style: TextStyle(color: Colors.teal),),
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
      child: const Text(
        'Oylama Oluştur', style: TextStyle(color: Colors.teal),),
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
    QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('apartmentId', isEqualTo: apartmentId)
        .where('role', isNotEqualTo: 'Apartman Yöneticisi')
        .get();

    if (flatSnapshot.docs.isNotEmpty) {
      for (var flat in flatSnapshot.docs) {
        sendNotificationToResident(flat.id, 'Yönetici bir duyuru paylaştı.');
      }
    }
  }
}