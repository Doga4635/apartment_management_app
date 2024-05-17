import 'package:apartment_management_app/screens/define_payment_screen.dart';


import 'package:apartment_management_app/screens/permission_screen.dart';
import 'package:apartment_management_app/screens/user_payment_done_screen.dart';
import 'package:apartment_management_app/screens/user_payment_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'ana_menü_yardım_screen.dart';
import 'multiple_flat_user_profile_screen.dart';

class ApartmentPaymentScreen extends StatefulWidget {
  const ApartmentPaymentScreen({Key? key}) : super(key: key);

  @override
  ApartmentPaymentScreenState createState() => ApartmentPaymentScreenState();
}

class ApartmentPaymentScreenState extends State<ApartmentPaymentScreen> {

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ödeme Ekranı', style: TextStyle(
            fontSize: 28,
          ),
          ),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                onPressed: () async {
                  ap.userSignOut().then((value) =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      ),
                  );
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/payment.png'),
              fit: BoxFit.fitHeight,
              opacity: 0.3,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  FutureBuilder<String>(
                    future: ap.getField('role'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if(snapshot.data == 'Apartman Yöneticisi') {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (
                                      context) => const DefinePaymentScreen()));
                            },
                            child: Container(
                              width: 320,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Ödeme Tanımlama Ekranı',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        else {
                          return const SizedBox(width: 2,height: 2,);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const UserPaymentScreen()));
                    },
                    child: Container(
                      width: 320,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Ödeme Takip Ekranı',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const UserPaymentDoneScreen()));
                      // Add your functionality here
                    },
                    child: Container(
                      width: 320,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Yapılmış Ödemeler',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
      ),
    );
  }
}