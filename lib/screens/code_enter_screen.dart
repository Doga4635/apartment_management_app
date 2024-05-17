import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/register_flat_screen.dart';
import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:apartment_management_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import 'ana_menü_yardım_screen.dart';

class CodeEnterScreen extends StatefulWidget {
  final String verificationId;
  const CodeEnterScreen({super.key, required this.verificationId});

  @override
  CodeEnterScreenState createState() => CodeEnterScreenState();
}

class CodeEnterScreenState extends State<CodeEnterScreen> {

  @override
  void initState() {
    super.initState();
  }

  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthSupplier>(context,listen: true).isLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading == true ? const Center(child: CircularProgressIndicator(
          color: Colors.teal,
        )) :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),
            const Icon(
              Icons.sms,
              size: 120,
              color: Colors.teal,
            ),
            const Text(
              'SMS Kodunu Giriniz',
              style: TextStyle(
                color: customTealShade900,
                fontSize: 28.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10,bottom: 15),
              child: Text(
                'Telefonunuza SMS ile gönderilen kodu giriniz.',
                style: greyTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                    width: 50,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.teal.shade200,
                        )
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    )
                ),
                onCompleted: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if(otpCode != null) {
                    verifyOTP(context, otpCode!);
                  }
                  else {
                    showSnackBar("6 haneli kodu girin.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                ),
                child: const Text('Gönder' , style: TextStyle(color: Colors.white),),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Koda ulaşamadınız mı?",
                style: greyTextStyle,
              ),
            ),
            const Text(
              "Kodu Yeniden Gönder",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const YardimScreen()),
          );
        },
        tooltip: 'Help',
        backgroundColor: Colors.teal,
        child: const Icon(Icons.question_mark,
          color: Colors.white,),
      ),
    );
  }

  void verifyOTP(BuildContext context,String userOtp) {
    final ap = Provider.of<AuthSupplier>(context,listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () {
          ap.checkExistingUser().then((value) async {
            if(value == true) {
              ap.getDataFromFirestore().then((value) =>
                  ap.saveUserDataToSP().then((value) =>
                      ap.setSignIn().then((value) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen(isAllowed: true,)),
                                  (route) => false))));
            }
            else {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RegisterFlatScreen()),
                      (route) => false);
            }
          });

        }
    );
  }

}