import 'package:apartment_management_app/screens/main_screen.dart';
import 'package:apartment_management_app/screens/permission_screen.dart';
import 'package:apartment_management_app/screens/user_profile_screen.dart';
import 'package:apartment_management_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'first_module_screen.dart';
import 'multiple_flat_user_profile_screen.dart';

class YardimScreen extends StatefulWidget {
  const YardimScreen({super.key});

  @override
  YardimScreenState createState() => YardimScreenState();
}

class YardimScreenState extends State<YardimScreen> {
  final String _helpText = '''
Uygulamamıza Hoş Geldiniz...

Bu uygulama, apartman yöneticilerinin ve konut sahiplerinin kollektif bir ortamda yaşadıkları sorunları çözmelerini ve iletişim kurmalarını sağlayan bir araçtır.

Apartman Yöneticisi:
- Yeni bir kullanıcı oluşturabilir veya mevcut bir kullanıcıyı yönetebilir.
- Yapılan tüm mesajları görüntüleyebilir.
- Yeni bir mesaj gönderebilir.

Konut Sahibi:
- Yapılan tüm mesajları görüntüleyebilir.
- Çöp bildirimi yapabilir.
- Günlük,haftalık ve aylık periyotlarda market,manav,fırın ve diğer siparişlerini oluşturup kapıcıya yönlendirebilir.

Uygulama nasıl kullanılır:
1. Kullanıcı adı ve şifre ile oturum açın.
2. Ana sayfada görüntülenen mesajları görüntüleyin.
3. Yeni bir mesaj göndermek için, yazı kutusuna mesajınızı yazıp "Gönder" butonuna basın.
4. Mesajınız gönderildikten sonra, yanıt aldığınızda bildirim alacaksınız.

Bize ulaşmak için:
[EFE DOĞA ÖZLEM ERDEM DURU]
''';

  final List<String> _buttonTexts = [
    'Apartman Sakini',
    'Apartman Yöneticisi',
    'Kapıcı',
  ];

  final List<List<String>> _nestedButtonTexts = [
    ['Kayıt Olma / Giriş Yapma','Genel Bilgiler','Alışveriş Modulü', 'Çöp Modulü', 'Ödeme İşlemleri' ],
    ['Genel Bilgiler','Alışveriş Modülü', 'Çöp Modülü', 'Ödeme İşlemleri'],
    ['Genel Bilgiler','Alışveriş Modulü', 'Çöp Modulü', 'Ödeme İşlemleri'],
  ];

  final List<List<Widget>> _nestedTextContents = [
    [

      // Apartman Sakini Kayıt Olma Giriş Yapma

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kayıt olmak için, apartman sakini, ilk olarak cep telefon numarasını tuşlamalı'
                        ' ve telefonuna gelen kodu girmelidir. Daha sonra açılan ekranda, apartmandaki'
                        ' rol, apartman, kat ve daire numarası bilgilerini doldurmalı ve kayıt olma işlemini '
                        'tamamlamak için "Kayıt Ol" tuşuna basmalıdır. Kullanıcı uygulamaya kayıt '
                        'olduktan sonra uygulamayı kullanabilmek için apartman yöneticisinin onayını beklemelidir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Uygulamaya daha önce kayıt yapmış bir kullanıcı, telefon numarasını ve'
                        ' telefonuna sms olarak gelen kodu girerek uygulamaya giriş yapabilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

          ],
        ),

      ),


     // Apartman Sakini Genel Bilgiler

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bu uygulamada, apartman sakini, günlük ve haftalık periyotlarda market, manav, fırın '
                        've diğer siparişlerini oluşturup kapıcıya yönlendirebilir. Kapıcıya çöpü olduğunu '
                        'bildirebilir. Apartman içi duyurulardan haberdar olup, yönetici tarafından oluşturulan, apartman içi oylama etkinliklerine '
                        'katılabilir. Yapması gereken ve yaptığı ödemeleri görüntüleyebilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.person,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman sakini, yukarıda gösterilen ve ekranın sağ üst kısmında bulunan '
                            'butonu kullanarak profil ekranına ulaşabilir. Kullanıcının sahip '
                            'olduğu birden fazla dairesi var ise, bu ekrandan "Daire Ekle" butonuna basarak'
                            ' ve açılan ekranda eklemek istediği dairesindeki rolünü, apartmanın adını,'
                            ' dairenin bulundaki katı ve daire numarasını seçerek sahip olduğu daireleri '
                            'uygulamaya ekleyebilir. Profil ekranında bu daireler görüntülenir. '
                            'İstenilen daireye tıklanarak, uygulama içinde, '
                            'konutlar arası geçiş yapılabilir.',
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allow the text to wrap to the next line
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.exit_to_app,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman sakini, yukarıda gösterilen ve ekranın sağ üst kısmında bulunan '
                            'butonu kullanarak profilinden çıkış yapabilir.',
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allow the text to wrap to the next line
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.announcement,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman sakini, yukarıda gösterilen ve ekranın sağ alt kısmında bulunan '
                            'butonu kullanarak apartman yöneticisinin yayınladığı duyuruları '
                            'görüntüleyebilir. Eğer yönetici bir konu üzerine oylama etkinliği '
                            'başlatmış ise, apartman sakini bu ekrandan oyunu kullanabilir.',
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allow the text to wrap to the next line
                      ),
                    ),
                  ],
                ),
              ],
            ),




          ],
        ),

      ),

      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.2', style: TextStyle(fontSize: 16)),
        ],
      ),

      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.3', style: TextStyle(fontSize: 16)),
        ],
      ),

      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.4', style: TextStyle(fontSize: 16)),
        ],
      ),

    ],
    [
      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.1', style: TextStyle(fontSize: 16)),
        ],
      ),

      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.2', style: TextStyle(fontSize: 16)),
        ],
      ),
      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.3', style: TextStyle(fontSize: 16)),
        ],
      ),
      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.4', style: TextStyle(fontSize: 16)),
        ],
      ),
    ],
    [
      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.1', style: TextStyle(fontSize: 16)),
        ],
      ),
      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.2', style: TextStyle(fontSize: 16)),
        ],
      ),
      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.3', style: TextStyle(fontSize: 16)),
        ],
      ),
      Row(
        children: [
          Icon(Icons.circle, size: 12, color: Colors.black),
          SizedBox(width: 8),
          Text('Content for Nested Button 1.4', style: TextStyle(fontSize: 16)),
        ],
      ),
    ],
  ];


  int? _expandedIndex;
  int? _nestedExpandedIndex;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yardım'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FutureBuilder(
              future: getRoleForFlat(ap.userModel.uid), // Assuming 'role' is the field that contains the user's role
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: Colors.teal,
                  ));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String userRole = snapshot.data ?? '';
                  return userRole == 'Apartman Yöneticisi' ? IconButton(
                    onPressed: () async {
                      String? apartmentName = await getApartmentIdForUser(ap.userModel.uid);

                      //Checking if the user has more than 1 role
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('flats')
                          .where('apartmentId', isEqualTo: apartmentName)
                          .where('isAllowed', isEqualTo: false)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const PermissionScreen()),
                        );
                      } else {
                        showSnackBar(
                            'Kayıt olmak için izin isteyen kullanıcı bulunmamaktadır.');
                      }
                    },
                    icon: const Icon(Icons.verified_user),
                  ) : const SizedBox(width: 2,height: 2);
                }
              }
          ),
          IconButton(
            onPressed: () async {
              String currentUserUid = ap.userModel.uid;

              //Checking if the user has more than 1 role
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('flats')
                  .where('uid', isEqualTo: currentUserUid)
                  .get();

              if (querySnapshot.docs.length > 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MultipleFlatUserProfileScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),

                );
              }
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              ap.userSignOut().then((value) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              ));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(_buttonTexts.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_expandedIndex == index) {
                                _expandedIndex = null;
                                _nestedExpandedIndex = null;
                              } else {
                                _expandedIndex = index;
                                _nestedExpandedIndex = null;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: Text(_buttonTexts[index]),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: _expandedIndex == index
                            ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              ...List.generate(_nestedButtonTexts[index].length, (nestedIndex) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_nestedExpandedIndex == nestedIndex) {
                                              _nestedExpandedIndex = null;
                                            } else {
                                              _nestedExpandedIndex = nestedIndex;
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal[200],
                                          foregroundColor: Colors.white,
                                          textStyle: const TextStyle(fontSize: 16),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 20, // Adjusted the horizontal padding
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          elevation: 5,
                                        ),
                                        child: Text(_nestedButtonTexts[index][nestedIndex]),
                                      ),
                                    ),
                                    AnimatedSize(
                                      duration: const Duration(milliseconds: 300),
                                      child: _nestedExpandedIndex == nestedIndex
                                          ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: _nestedTextContents[index][nestedIndex],
                                      )
                                          : const SizedBox.shrink(),
                                    ),

                                    const SizedBox(height: 8),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
