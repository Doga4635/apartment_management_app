import 'dart:io';
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