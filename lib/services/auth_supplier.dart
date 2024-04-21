import 'dart:collection';
import 'dart:convert';

import 'package:apartment_management_app/models/flat_model.dart';
import 'package:apartment_management_app/models/message_model.dart';
import 'package:apartment_management_app/models/order_model.dart';
import 'package:apartment_management_app/models/user_model.dart';
import 'package:apartment_management_app/screens/code_enter_screen.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/list_model.dart';
import '../models/payment_model.dart';

class AuthSupplier extends ChangeNotifier {

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthSupplier() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.setSettings(appVerificationDisabledForTesting: true);
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId,forceResendingToken) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeEnterScreen(verificationId: verificationId,),
            ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {} );
    } on FirebaseAuthException catch(e) {
      showSnackBar(e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  })
  async {
    _isLoading = true;
    notifyListeners();

    try{
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: userOtp);
      User user = (await _firebaseAuth.signInWithCredential(creds)).user!;

        _uid = user.uid;
        onSuccess();

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseFirestore.collection("users").doc(_uid).get();
    if(snapshot.exists) {
      return true;
    }
    else {
      return false;
    }
  }

  void saveUserDataToFirebase ({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
      userModel.uid = _firebaseAuth.currentUser!.uid;
      _userModel = userModel;

      await _firebaseFirestore.collection("users").doc(userModel.uid).set(userModel.toMap()).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();

      });
    } on FirebaseAuthException catch(e) {
      showSnackBar(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  void saveFlatDataToFirebase ({
    required BuildContext context,
    required FlatModel flatModel,
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
      flatModel.uid = _firebaseAuth.currentUser!.uid;

      await _firebaseFirestore.collection("flats").doc(flatModel.flatId).set(flatModel.toMap()).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();

      });
    } on FirebaseAuthException catch(e) {
      showSnackBar(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  void saveOrderDataToFirebase ({
    required BuildContext context,
    required OrderModel orderModel,
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
      await _firebaseFirestore.collection("orders").doc(orderModel.orderId).set(orderModel.toMap()).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();

      });
    } on FirebaseAuthException catch(e) {
      showSnackBar(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  savePaymentDataToFirebase ({
    required BuildContext context,
    required PaymentModel paymentModel,
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
      await _firebaseFirestore.collection("payments").doc(paymentModel.id).set(paymentModel.toMap()).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();

      });
    } on FirebaseAuthException catch(e) {
      showSnackBar(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  saveListDataToFirebase ({
    required BuildContext context,
    required ListModel listModel,
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
      await _firebaseFirestore.collection("lists").doc(listModel.listId).set(listModel.toMap()).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();

      });
    } on FirebaseAuthException catch(e) {
      showSnackBar(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  saveMessageDataToFirebase ({
    required BuildContext context,
    required MessageModel messageModel,
    required Function onSuccess
  }) async {
    _isLoading = true;
    notifyListeners();
    try{
      await _firebaseFirestore.collection("messages").doc(messageModel.messageId).set(messageModel.toMap()).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();

      });
    } on FirebaseAuthException catch(e) {
      showSnackBar(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore.collection("users").doc(_firebaseAuth.currentUser!.uid).get().then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
          uid: snapshot['uid'],
          name: snapshot['name'],
          role: snapshot['role'],
          apartmentName: snapshot['apartmentName'],
          flatNumber: snapshot['flatNumber'], profilePic: '',
      );
      _uid = userModel.uid;
    });
  }

  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

    Future<String> getField(String data) async {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid);
    DocumentSnapshot snapshot1 = await userDocRef.get();
    String value = snapshot1[data];
    return value;
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

}