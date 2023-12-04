import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyD58_QFHFqmFg38D_Tj7Ju10tygKj_Cfr0', appId: '1:1067337184366:android:e5f2590c4bced93778e27f', messagingSenderId: '1067337184366', projectId: 'fir-c17f4', storageBucket: "fir-c17f4.appspot.com",));
  runApp(const MyApp());
  }

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (_) => AuthSupplier()),
        ],
      child: const MaterialApp(
        home: WelcomeScreen(),
      ),
    );
  }
}

// options: const FirebaseOptions(apiKey: 'AIzaSyD58_QFHFqmFg38D_Tj7Ju10tygKj_Cfr0', appId: '1:1067337184366:android:e5f2590c4bced93778e27f', messagingSenderId: '1067337184366', projectId: 'fir-c17f4')


// return StreamProvider<UserModel?>.value(
// value: AuthService().user,
// initialData: null,
// child: const MaterialApp(
// home: RegisterScreen(),
// ),
// );

// Wrapper()
