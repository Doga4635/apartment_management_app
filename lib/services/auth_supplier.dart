import 'dart:convert';

import 'package:apartment_management_app/models/user_model.dart';
import 'package:apartment_management_app/screens/code_enter_screen.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      showSnackBar(context, e.message.toString());
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

      if(user != null) {
        _uid = user.uid;
        onSuccess();
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseFirestore.collection("users").doc(_uid).get();
    if(snapshot.exists) {
      print("User exists");
      return true;
    }
    else {
      print("New User");
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

      await _firebaseFirestore.collection("users").doc(_uid).set(userModel.toMap()).then((value) {
      onSuccess();
      _isLoading = false;
      notifyListeners();

      });
    } on FirebaseAuthException catch(e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }

  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore.collection("users").doc(_firebaseAuth.currentUser!.uid).get().then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
          uid: snapshot['uid'],
          role: snapshot['role'],
          apartmentName: snapshot['apartmentName'],
          flatNumber: snapshot['flatNumber']
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

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

}