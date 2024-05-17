import 'package:apartment_management_app/services/auth_supplier.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:apartment_management_app/constants.dart';
import 'package:provider/provider.dart';

import 'ana_menü_yardım_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController phoneController = TextEditingController();
  
  Country selectedCountry = Country(
      phoneCode: "90",
      countryCode: "TR",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Turkey",
      example: "Turkey",
      displayName: "Turkey",
      displayNameNoCountryCode: "TR",
      e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return  GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.home,
                    size: 120,
                    color: Colors.teal,
                  ),
                  const Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      color: customTealShade900,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Yeni Bir Hesap Oluştur',
                    style: greyTextStyle
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,left: 30,right: 30,bottom: 10),
                    child: TextFormField(
                      controller: phoneController,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLength: 10,
                      onChanged: (value) {
                        setState(() {
                          phoneController.text = value;
                        });
                      },
                      cursorColor: Colors.teal,
                      decoration: InputDecoration(
                        hintText: "Cep Telefonu",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                  context: context,
                                  countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 500,
                                  ),
                                  onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              });
                            },
                            child: Text(
                             "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        suffixIcon: phoneController.text.length > 9 ? Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green
                          ),
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                       : null,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:  () => sendPhoneNumber(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 70.0,vertical: 15.0),
                    ),
                    child: const Text(
                      'Devam Et',
                      style: TextStyle(color: Colors.white),
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
          ),
    );

  }

  void sendPhoneNumber() {
    //+901234567890
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");

  }
}

