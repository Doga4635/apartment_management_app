import 'package:apartment_management_app/screens/apartment_payment_screen.dart';
import 'package:apartment_management_app/screens/first_module_screen.dart';
import 'package:apartment_management_app/screens/permission_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/payment_model.dart';
import 'ana_menü_yardım_screen.dart';
import 'annoucement_screen.dart';
import 'multiple_flat_user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isAllowed;
  const MainScreen({super.key, required this.isAllowed});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/firebase.messaging']);

  @override
  void initState() {
    super.initState();
    getToken();
    //checkPaymentsAndNotifyResidents();
  }


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return widget.isAllowed ? Scaffold(
      appBar: AppBar(
        title: const Text('Ana Menü', style: TextStyle(fontSize: 28)),
        backgroundColor: Colors.teal,
        actions: [
          FutureBuilder(
    future: getRoleForFlat(ap.userModel.uid), // Assuming 'role' is the field that contains the user's role
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator(
          color: Colors.teal,
        ));
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        String userRole = snapshot.data ?? '';
        return userRole == 'Apartman Yöneticisi' ? IconButton(
          onPressed: () async {
            String? apartmentName = await getApartmentIdForUser(ap.userModel.uid);

            //Checking if the user has more than 1 role
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('flats')
                .where('apartmentId', isEqualTo: apartmentName)
                .where('isAllowed', isEqualTo: false)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (
                    context) => const PermissionScreen()),
              );
            } else {
              showSnackBar(
                  'Kayıt olmak için izin isteyen kullanıcı bulunmamaktadır.');
            }
          },
          icon: const Icon(Icons.verified_user),
        ) : const SizedBox(width: 2,height: 2);
      }
    }
          ),
          IconButton(
            onPressed: () async {
              String currentUserUid = ap.userModel.uid;

              //Checking if the user has more than 1 role
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                 .collection('flats')
                 .where('uid', isEqualTo: currentUserUid)
                 .get();

              if (querySnapshot.docs.length > 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MultipleFlatUserProfileScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),

                );
              }
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              ap.userSignOut().then((value) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              ));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (
                            context) => const FirstModuleScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(320, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Kapıcı İşlemleri",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (
                            context) => const ApartmentPaymentScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Bireysel Ödeme İşlemleri",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              )
            ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnnouncementScreen()),
              );
            },
            tooltip: 'Duyuru',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.announcement,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const YardimScreen()),
            );},
            tooltip: 'Yardım',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.question_mark,
              color: Colors.white,
            ),
          ),
        ],

      ),
    ) :
    Scaffold(
        appBar: AppBar(
          title: const Text('Ana Menü', style: TextStyle(fontSize: 28)),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                String currentUserUid = ap.userModel.uid;

                //Checking if the user has more than 1 role
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('flats')
                    .where('uid', isEqualTo: currentUserUid)
                    .get();

                if (querySnapshot.docs.length > 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MultipleFlatUserProfileScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserProfileScreen()),

                  );
                }
              },
              icon: const Icon(Icons.person),
            ),
            IconButton(
              onPressed: () {
                ap.userSignOut().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                ));
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.only(left: 24.0,top: 5.0,right: 24.0,bottom: 5.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: const Text('Daire girişiniz için yönetici izni beklenmektedir.',
                style: TextStyle(color: Colors.white,fontSize: 36),
              ),),
          ),
        ),
    );
  }

  void getToken() async {
    String? accessToken = await FirebaseAuth.instance.currentUser!.getIdToken();

    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'accessToken': accessToken,
    });

    await _firebaseMessaging.getToken().then((value) {
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'deviceToken': value,
      });
      print(value);
    });
  }

  Future<void> checkPaymentsAndNotifyResidents() async {
    DateTime now = DateTime.now();
    DateTime thresholdDate = now.add(const Duration(days: 2));

    try {
      // Fetch payments from Firestore
      QuerySnapshot paymentSnapshot = await FirebaseFirestore.instance.collection('paymentss').get();

      for (var paymentDoc in paymentSnapshot.docs) {
        PaymentModel payment = PaymentModel(
          id: paymentDoc['id'],
          name: paymentDoc['name'],
          apartmentId: paymentDoc['apartmentId'],
          description: paymentDoc['description'],
          price: paymentDoc['price'],
          flatNo: paymentDoc['flatNo'],
          paid: paymentDoc['paid'],
          dueDate: paymentDoc['dueDate'].toDate(),
        );

        Timestamp now = Timestamp.now();
        final int daysInMilliseconds = 2 * 24 * 60 * 60 * 1000;
        Timestamp twoDaysBeforeDueDate = Timestamp.fromMillisecondsSinceEpoch(
            payment.dueDate.millisecondsSinceEpoch - daysInMilliseconds);
        // Check if the payment is not paid and the due date is within 2 days
        if (!payment.paid && twoDaysBeforeDueDate.compareTo(now) < 0) {
    // Fetch the flat information
    QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('flatNo', isEqualTo: payment.flatNo)
        .where('apartmentId', isEqualTo: payment.apartmentId)
        .where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (flatSnapshot.docs.isNotEmpty) {
    String flatId = flatSnapshot.docs.first['flatId'];
    // Send notification to the flat
    String formattedDueDate = DateFormat('dd-MM-yyyy').format(payment.dueDate as DateTime);
    sendNotificationToResident(flatId, '${payment.name} ödemesinin tarihi yaklaşıyor: $formattedDueDate');
    }
    }
    }
    } catch (e) {
    print('Error checking payments and sending notifications: $e');
    }
  }

}