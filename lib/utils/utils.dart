import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showSnackBar(String content) {
  final SnackBar snackBar = SnackBar(content: Text(content));
  snackbarKey.currentState?.showSnackBar(snackBar);
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch(e) {
    showSnackBar(e.toString());
  }

  return image;
}

String generateRandomId(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

Future<String?> getRoleForFlat(String flatUid) async {
  String? role;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: flatUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      role = querySnapshot.docs.first['role'];
    }
  } catch (error) {
    showSnackBar('Rolü görmede sorun oldu.');
  }

  return role;
}

   String getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Pazartesi';
      case 2:
        return 'Salı';
      case 3:
        return 'Çarşamba';
      case 4:
        return 'Perşembe';
      case 5:
        return 'Cuma';
      case 6:
        return 'Cumartesi';
      case 7:
        return 'Pazar';
      default:
        return '';
    }
  }

