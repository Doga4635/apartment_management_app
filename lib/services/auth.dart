import 'dart:html';
import 'package:apartment_management_app/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user) {
     return user != null ? UserModel(uid:user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }
  //sign in anon
  Future signInAnon() async{
    try {
     UserCredential result = await _auth.signInAnonymously();
     User? user = result.user;
     return _userFromFirebaseUser(user);
    }
    catch(e) {
     print(e.toString());
     return null;
    }
}

  //sign in with email/password

  //register with email/password

  //sign out
}