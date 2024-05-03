import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/flat_model.dart';

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

Future<String?> getApartmentIdForUser(String uid) async {
  String? apartmentId;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: uid)
        .where('selectedFlat', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      apartmentId = querySnapshot.docs.first['apartmentId'];
    }
  } catch (error) {
    showSnackBar('Apartman ismi alınamadı.');
  }

  return apartmentId;
}

Future<String?> getSelectedFlatIdForUser(String uid) async {
  String? flatId;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: uid)
        .where('selectedFlat', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      flatId = querySnapshot.docs.first['flatId'];
    }
  } catch (error) {
    showSnackBar('Apartman ismi alınamadı.');
  }

  return flatId;
}

Future<String?> getProductPrice(String productName) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('name', isEqualTo: productName)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot userDoc = querySnapshot.docs.first;
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    if (userData != null && userData.containsKey('price')) {
      int price = userData['price'] as int;
      return price.toString();
    } else {
      return null;
    }
  } else {
    return null;
  }
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

Future<String?> getFlatIdForUser(String uid) async {
  String? flatId;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: uid)
        .where('selectedFlat', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      flatId = querySnapshot.docs.first['flatId'];
    }
  } catch (error) {
    showSnackBar('Daire ismi alınamadı.');
  }

  return flatId;
}

Future<List<Map<String, dynamic>>> getOrdersForFlat(String flatNo, String floorNo,String day) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('orders')
      .where('flatNo', isEqualTo: flatNo)
      .where('floorNo', isEqualTo: floorNo)
      .where('days',arrayContains: 'day')
      .get();

  return result.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}


Future<String> fetchFlatId(String userUid) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: userUid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final flatModel = FlatModel.fromSnapshot(snapshot.docs.first);
      final fetchedFlatId = flatModel.flatId;

      // Check if the fetched flatId is valid
      final isValidFlatId = await validateFlatId(fetchedFlatId);
      if (isValidFlatId) {
        return fetchedFlatId;
      }
    }
  } catch (error) {
    print('Error fetching flatId: $error');
  }

  return ''; // Return an empty string if flatId is not valid or not found
}

Future<bool> validateFlatId(String flatId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('flatId', isEqualTo: flatId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  } catch (error) {
    print('Error validating flatId: $error');
    return false;
  }


}

Future<String> fetchFirstFlatIdForFloor(String floor) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('flats')
      .where('floorNo', isEqualTo: floor)
      .where('grocery', isEqualTo: false)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.get('flatId');
  } else {
    return '';
  }
}