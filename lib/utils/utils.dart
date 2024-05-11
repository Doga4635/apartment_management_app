import 'dart:convert';
import 'dart:math';
import 'package:apartment_management_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/flat_model.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showSnackBar(String content) {
  final SnackBar snackBar = SnackBar(content: Text(content));
  snackbarKey.currentState?.showSnackBar(snackBar);
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
        .where('selectedFlat', isEqualTo: true)
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

Future<UserModel?> getUserById(String? uid) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      UserModel userModel = UserModel(
        uid: doc['uid'],
        role: doc['role'],
        name: doc['name'],
        apartmentName: doc['apartmentName'],
        flatNumber: doc['flatNumber'],
        deviceToken: doc['deviceToken'],
          accessToken: doc['accessToken'],
      );
      return userModel;
    } else {
      return null;
    }
  } catch (error) {
    showSnackBar('Kullanıcı tanımlanırken hata oldu.');
    return null;
  }
}

void sendNotificationToResident(String flatId, String body) async {
  String? uid;
  String serverKey = 'AAAA-IJA9G4:APA91bGibOwdCxMOkoJKMcO5kzIZtYpXzYDOggE8qNJ4K-jFTZ2miuCqjoD0tfSU4olwyqOhNukvniWuSNEBCZiYMHmSjxb77qF46t3JsrnviwxKQrjyFV3ygKvD5t5H7mqodPK2VU5z';

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('flatId', isEqualTo: flatId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      uid = querySnapshot.docs.first['uid'];
    }
  } catch (error) {
    showSnackBar('Apartman ismi alınamadı.');
  }

  UserModel? userModel = await getUserById(uid);

  // Define the endpoint URL of your FCM server
  String url = 'https://fcm.googleapis.com/fcm/send';

  // Define the headers required for sending a notification
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  // Define the notification message
  Map<String, dynamic> notification = {
    'notification': {
      'title': '${userModel!.apartmentName} Daire: ${userModel.flatNumber}',
      'body': body},
    'to': userModel.deviceToken,
  };

  // Convert the notification message to JSON format
  String jsonBody = json.encode(notification);

  try {
    // Send the notification using HTTP POST request
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    // Check the response status
    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
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

Future<double?> getBalanceForFlat(String uid) async {
  double? balance;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: uid)
        .where('selectedFlat', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      balance = querySnapshot.docs.first['balance'];
    }
  } catch (error) {
    showSnackBar('Apartman ismi alınamadı.');
  }

  return balance;
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
      double price = userData['price'] as double;
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

Future<bool> getAllowedForUser(String uid) async {
  late bool isAllowed;


  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: uid)
        .where('selectedFlat', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      isAllowed = querySnapshot.docs.first['isAllowed'];
    }
    // else {
    //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //       .collection('flats')
    //       .where('uid', isEqualTo: uid)
    //       .get();
    //
    //   var doc = querySnapshot.docs.first;
    //   var docId = doc.id;
    //   isAllowed = doc['isAllowed'];
    //   FirebaseFirestore.instance.collection('flats').doc(docId).update({
    //     'selectedFlat': true,
    //   });
    // }
  } catch (error) {
    showSnackBar('Daire ismi alınamadı.');
  }
  return isAllowed;
}

Future<List<Map<String, dynamic>>> getOrdersForFlat(String flatNo, String floorNo,String day, apartmentId) async {
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
    showSnackBar('Daire alınırken hata oluştu: $error');
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
    showSnackBar('Daire doğrulanırken hata oluştu: $error');
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