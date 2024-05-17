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

  final List<String> _buttonTexts = [
    'Apartman Sakini',
    'Apartman Yöneticisi',
    'Kapıcı',
  ];

  final List<List<String>> _nestedButtonTexts = [
    ['Kayıt Olma / Giriş Yapma','Genel Bilgiler','Alışveriş Modulü', 'Çöp Modulü', 'Ödeme İşlemleri' ],
    ['Kayıt Olma / Giriş Yapma','Genel Bilgiler','Alışveriş Modülü', 'Çöp Modülü', 'Ödeme İşlemleri'],
    ['Kayıt Olma / Giriş Yapma','Genel Bilgiler','Alışveriş Modulü', 'Çöp Modulü'],
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
                        'bildirebilir. Apartman içi duyurulardan haberdar olup, yönetici tarafından '
                        'oluşturulan, apartman içi oylama etkinliklerine '
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

      // Apartman Sakini Alışveriş Modülü

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Apartman sakini, kapıcıya sipariş vermek için ilk olarak ana ekrandan "Kapıcı İşlemleri" '
                        'butonuna, daha sonra da açılan sayfada "Kapıcıya Alışveriş Listesi" butonuna tıklamalıdır. ',
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
                    '"Listeler" ekranını görüntüleyen kullanıcı, eğer daha önce hiç liste oluşturmadıysa '
                        '"Liste Oluştur" butonuna tıkladıktan sonra, '
                        'listeye isim vererek, "Zaman Seçiniz" butonuyla siparişin tekrarlanma sıklığını '
                        'istenilen günleri seçerek belirleyip "Oluştur" butonuna tıklayıp alışveriş listesini oluşturabilir. ',
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
                    ' "Yeni Liste" ekranında kullanıcı, uygulamaya tanımlanmış istediği ürünün adını seçebilir ya da "Diğer" '
                        'seçeneğine tıklayarak istediği ürünü çıkan boşluğa yazabilir. "+", "-" tuşlarıyla ürün adedi '
                        'belirlenir. Eğer kullanıcının kapıcıya belirtmek istediği bir detay varsa "Not" kısmına yazabilir. '
                        'Kullanıcı ürününün belli bir yerden alınmasını istiyor ise "Yeri Seçiniz" kısmından uygulamaya tanımlanmış '
                        'yerlerden birini seçebilir veya "Diğer" seçeneğine tıklayarak açılan boşluğa alışveriş yerini yazabilir. "Listeye Ekle" '
                        'butonuyla ürün listeye eklenir. Daha sonra istenilen diğer ürünler için kullanıcı aynı işlemleri tekrarlamalıdır.'
                        ' Tüm ürünler eklendikten sonra "Liste Oluştur" butonuna tıklayarak kullanıcı alışveriş listesini oluşturmayı tamamlar. '
                        'Oluşturulan listeler "Listeler" ekranında sipariş gününe göre gösterilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.delete,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman sakini, yukarıda gösterilen ve "Listeler" ekranında oluşturulmuş her listenin '
                            'yanında bulunan butona tıklayarak listeleri silebilir. Eğer liste birkaç gün için oluşturulmuşsa '
                            've bir günden silindiyse diğer günlerden silinmez. Listeyi oluşturulan her günden silmek için'
                            ' silme işlemi her gün için ayrı ayrı yapılmalıdır.',
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
                Icon(Icons.edit,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          'Daha önce oluşturulmuş bir listeyi görüntülemek veya düzenlemek için, "Listeler" ekranından düzenlenmek istenen listenin'
                          ' üzerine tıklanmalıdır. Açılan ekranda, yukarıda gösterilen ve her ürün bilgisi kutucuğunun yanında '
                              'bulunan butona tıklanılarak değiştirilmek istenilen ürün bilgisi değiştirilebilir.',
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
                Icon(Icons.check,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ürün bilgileri değiştirildikten sonra yukarıda gösterilen ve değiştirilen ürün bilgisi kutucuğunun yanında '
                            'bulunan butona tıklayarak değişiklikler kayıt edilir.',
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allow the text to wrap to the next line
                      ),
                    ),
                  ],
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
                    '"Listeler" ekranının alt kısmında sakin anlık bütçesini görüntüleyebilir. '
                        'Kapıcı dağıtım esnasında, sakinden aldığı ücreti uygulamaya girer. Eğer sakin eksik ödeme yaptıysa '
                        '"bütçeniz" kısmında "kırmızı" renkte kapıcıya olan borcunu görüntüler. Eğer sakin sonraki alışverişler '
                        'için kapıcıya ekstra para verdiyse, "bütçeniz" kısmında "yeşil" renkte var olan parasını görüntüleyebilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),


          ],
        ),

      ),

      // Apartman Sakini Çöp Modülü

       Expanded(
        child: Column(
          children: [

            Column(
              children: [
                Container(
                  height: 80,
                  width: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Image.asset(
                    "images/çöpüm_var.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman Sakini, çöpü olduğunu kapıcıya bildirmek için, ilk olarak ana ekrandan "Kapıcı İşlemleri" '
                            'butonuna basmalıdır. Açılan sayfada, yukarıdaki resimde gösterildiği gibi '
                            '"Çöpüm var" kısmında "Evet" kısmına tıklamalıdır.',
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
                Container(
                  height: 80,
                  width: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Image.asset(
                    "images/çöpüm_yok.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman Sakini, kapıcı çöpünü attığında bir bildirim alır ve yukarda gösterildiği gibi,'
                            ' tekrardan, "Çöpüm var" '
                            'butonunu "Hayır" seçeneğinde görüntüleyecektir.',
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

      // Apartman Sakini Ödeme İşlemleri

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Apartman Sakini yöneticiye ödemesi gereken tutarları görüntülemek için ilk olarak ana ekranda '
                        '"Bireysel Ödeme İşlemleri" butonuna, daha sonra "Ödeme Takip Ekranı" butonuna tıklamalıdır.',
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
                    '"Ödeme Takip Ekranı" açıldığında ekranın en üst kısmında kullanıcının apartmana olan '
                        'kendi toplam borcu görüntülenir. '
                        'Toplam borcun altında, ayrı ayrı ödemeler, sebepleri, ödemeye ait açıklama, miktar  ve '
                        'son ödeme tarihleri listelenir.',
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
                    'Kullanıcı son ödeme tarihine 2 gün kala hala ödemeyi yapmamışsa uygulamaya girdiğinde '
                        'bu konu hakkında bir bildirim alır.',
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
                    'Apartman Sakini ödemeyi yaptıktan sonra, ödemesinin durumunun "Ödendi" durumuna geçmesi için '
                        'yönetici onayını beklemelidir.',
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
                    'Apartman Sakini yöneticiye yaptığı geçmiş ödemeleri görüntülemek için ilk olarak ana ekranda '
                        '"Bireysel Ödeme İşlemleri" butonuna, daha sonra "Yapılmış Ödemeler" butonuna tıklamalıdır.',
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
                    '"Yapılmış Ödemeler" ekranı açıldığında ekranın en üst kısmında kullanıcının apartmana '
                        'yaptığı ödemelerin toplam tutarı görüntülenir. '
                        'Toplam tutarın altında, ayrı ayrı ödemeler, sebepleri, ödemeye adit açıklamalar listelenir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

          ],
        ),

      ),

    ],
    [

      // Apartman Yöneticisi Kayıt Olma Giriş Yapma

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kayıt olmak için, apartman yöneticisi, ilk olarak cep telefon numarasını tuşlamalı'
                        ' ve telefonuna gelen kodu girmelidir. Daha sonra açılan ekranda, apartmandaki'
                        ' rolünü seçip bir apartman oluşturmalıdır. Oturduğu kat ve daireyi de seçtikten sonra '
                        'kayıt işlemini tamamlamak için "Kayıt Ol" tuşuna basmalıdır.',
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

      // Apartman Yöneticisi Genel Bilgiler

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bu uygulamada, apartman yöneticisi, günlük ve haftalık periyotlarda market, manav, fırın '
                        've diğer siparişlerini oluşturup kapıcıya yönlendirebilir. Kapıcıya çöpü olduğunu '
                        'bildirebilir. Apartman içi duyurular ve oylama etkinlikleri oluşturabilir.  '
                        'Apartman Sakinlerine ödemeleri için ödemeler oluşturabilir, ödemelerin durumlarını '
                        'takip edebilir, ödemesi yapılan ödemeleri onaylayabilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.verified_user,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman yöneticisi, yukarıda gösterilen ve ekranın sağ üst kısmında bulunan '
                            'butonu kullanarak onay bekleyen, yeni kayıt yapmış apartman sakinleri ve kapıcıların'
                            'kayıt bilgilerini kontrol ederek, uygulamaya girişlerini onaylayabilir. Eğer sakin veya kapıcı'
                            'yanlış bilgilerle kayıt olmuşsa kayıtlarını reddederek baştan yapmalarını sağlayabilir.',
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
                Icon(Icons.person,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman yöneticisi, yukarıda gösterilen ve ekranın sağ üst kısmında bulunan '
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
                        'Apartman yöneticisi, yukarıda gösterilen ve ekranın sağ üst kısmında bulunan '
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
                        'Apartman yöneticisi, yukarıda gösterilen ve ekranın sağ alt kısmında bulunan '
                            'butonu kullanarak apartman sakinlerine ve kapıcıya duyurular ve oylama etkinlikleri oluşturabilir.'
                            'Ayrıca bu ekrandan, yayınladığı duyuruları ve oluşturduğu oylama etkinliklerinin'
                            'sonuçlarını görüntüleyebilir.',
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

      // Apartman Yöneticisi Alışveriş Modülü

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Apartman yöneticisi, kapıcıya sipariş vermek için ilk olarak ana ekrandan "Kapıcı İşlemleri" '
                        'butonuna, daha sonra da açılan sayfada "Kapıcıya Alışveriş Listesi" butonuna tıklamalıdır. ',
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
                    '"Listeler" ekranını görüntüleyen yönetici, eğer daha önce hiç liste oluşturmadıysa '
                        '"Liste Oluştur" butonuna tıkladıktan sonra, '
                        'listeye isim vererek, "Zaman Seçiniz" butonuyla siparişin tekrarlanma sıklığını '
                        'istenilen günleri seçerek belirleyip "Oluştur" butonuna tıklayıp alışveriş listesini oluşturabilir. ',
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
                    ' "Yeni Liste" ekranında kullanıcı, uygulamaya tanımlanmış istediği ürünün adını seçebilir ya da "Diğer" '
                        'seçeneğine tıklayarak istediği ürünü çıkan boşluğa yazabilir. "+", "-" tuşlarıyla ürün adedi '
                        'belirlenir. Eğer kullanıcının kapıcıya belirtmek istediği bir detay varsa "Not" kısmına yazabilir. '
                        'Kullanıcı ürününün belli bir yerden alınmasını istiyor ise "Yeri Seçiniz" kısmından uygulamaya tanımlanmış '
                        'yerlerden birini seçebilir veya "Diğer" seçeneğine tıklayarak açılan boşluğa alışveriş yerini yazabilir. "Listeye Ekle" '
                        'butonuyla ürün listeye eklenir. Daha sonra istenilen diğer ürünler için kullanıcı aynı işlemleri tekrarlamalıdır.'
                        ' Tüm ürünler eklendikten sonra "Liste Oluştur" butonuna tıklayarak kullanıcı alışveriş listesini oluşturmayı tamamlar. '
                        'Oluşturulan listeler "Listeler" ekranında sipariş gününe göre gösterilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.delete,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman yöneticisi, yukarıda gösterilen ve "Listeler" ekranında oluşturulmuş her listenin '
                            'yanında bulunan butona tıklayarak listeleri silebilir. Eğer liste birkaç gün için oluşturulmuşsa '
                            've bir günden silindiyse diğer günlerden silinmez. Listeyi oluşturulan her günden silmek için'
                            ' silme işlemi her gün için ayrı ayrı yapılmalıdır.',
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
                Icon(Icons.edit,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Daha önce oluşturulmuş bir listeyi görüntülemek veya düzenlemek için, "Listeler" ekranından düzenlenmek istenen listenin'
                            ' üzerine tıklanmalıdır. Açılan ekranda, yukarıda gösterilen ve her ürün bilgisi kutucuğunun yanında '
                            'bulunan butona tıklanılarak değiştirilmek istenilen ürün bilgisi değiştirilebilir.',
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
                Icon(Icons.check,color: Colors.red,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ürün bilgileri değiştirildikten sonra yukarıda gösterilen ve değiştirilen ürün bilgisi kutucuğunun yanında '
                            'bulunan butona tıklayarak değişiklikler kayıt edilir.',
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allow the text to wrap to the next line
                      ),
                    ),
                  ],
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
                    '"Listeler" ekranının alt kısmında yönetici anlık bütçesini görüntüleyebilir. '
                        'Kapıcı dağıtım esnasında, yöneticiden aldığı ücreti uygulamaya girer. Eğer yönetici eksik ödeme yaptıysa '
                        '"bütçeniz" kısmında "kırmızı" renkte kapıcıya olan borcunu görüntüler. Eğer yönetici sonraki alışverişler '
                        'için kapıcıya ekstra para verdiyse, "bütçeniz" kısmında "yeşil" renkte var olan parasını görüntüleyebilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),


          ],
        ),

      ),

      // Apartman Yöneticisi Çöp Modülü

      Expanded(
        child: Column(
          children: [

            Column(
              children: [
                Container(
                  height: 80,
                  width: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Image.asset(
                    "images/çöpüm_var.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman Yöneticisi, çöpü olduğunu kapıcıya bildirmek için, ilk olarak ana ekrandan "Kapıcı İşlemleri" '
                            'butonuna basmalıdır. Açılan sayfada, yukarıdaki resimde gösterildiği gibi '
                            '"Çöpüm var" kısmında "Evet" kısmına tıklamalıdır.',
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
                Container(
                  height: 80,
                  width: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Image.asset(
                    "images/çöpüm_yok.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Apartman Yöneticisi, kapıcı çöpünü attığında bir bildirim alır ve  yukarda gösterildiği gibi, '
                            'tekrardan, "Çöpüm var" '
                            'butonunu "Hayır" seçeneğinde görüntüleyecektir.',
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

      // Apartman Yöneticisi Ödeme İşlemleri

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Apartman Yöneticisi, sakinlere ödeme tanımlamak için ilk olarak ana ekranda '
                        '"Bireysel Ödeme İşlemleri" butonuna, daha sonra "Ödeme Tanımlama Ekranı" butonuna tıklamalıdır.',
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
                    '"Ödeme Tanımlama Ekranı" açıldığında yönetici, sırasıyla ödeme ismi, ödeme miktarı, ödeme açıklaması, '
                        'ödemeyi yapacak daireler ve son ödeme tarihi kısımlarını doldurmalı, '
                        'eğer ödemeyi tüm daireye tanımlayacaksa "tüm daireler" seçeneğini seçmeli '
                        've tanımlamayı bitirdiğinde "Kaydet"'
                        ' butonuna tıklamalıdır.',
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
                    'Apartman Yöneticisi, sakinlerin ödemelerini takip etmek için ilk olarak ana ekranda '
                        '"Bireysel Ödeme İşlemleri" butonuna, daha sonra "Ödeme Takip Ekranı" butonuna tıklamalıdır.',
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
                    '"Ödeme Takip Ekranı" açıldığında yönetici en üstte apartmanın genel borcunu, '
                        'alt kısımda da her dairenin bütün ödemelerini listelenmiş olarak, isimlerini, '
                        'ödemenin hangi dairelere ait olduğunu, ödemelerin son ödeme tarihlerini, miktarlarını '
                        've açıklamalarını görüntüler.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.check,color: Colors.green,),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"Ödeme Takip Ekranı" ekranında her ödemenin altında yukarıda gösterilen buton bulunur. '
                            'Apartman sakinleri ödemeyi yaptığında yönetici bu butona tıklayarak ödemeleri onaylar. ',
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allow the text to wrap to the next line
                      ),
                    ),
                  ],
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
                    'Apartman Yöneticisi, sakinlerin yaptığı geçmiş ödemeleri görüntülemek için ilk olarak ana ekranda '
                        '"Bireysel Ödeme İşlemleri" butonuna, daha sonra "Yapılmış Ödemeler" butonuna tıklamalıdır. Bu '
                        'ekranda eski ödemeler, sebepleri, açıklamaları, miktarları ve ödemeleri yapan daireler görüntülenir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

          ],
        ),

      ),
    ],


    [

      // Kapıcı kayıt olma giriş yapma

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kayıt olmak için, kapıcı, ilk olarak cep telefon numarasını tuşlamalı'
                        ' ve telefonuna gelen kodu girmelidir. Daha sonra açılan ekranda, apartmandaki'
                        ' rol, apartman, kat ve daire numarası bilgilerini doldurmalı ve kayıt olma işlemini '
                        'tamamlamak için "Kayıt Ol" tuşuna basmalıdır. Kapıcı uygulamaya kayıt '
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

      // Kapıcı Genel bilgiler

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bu uygulamada, kapıcı, apartman sakinlerinin ve yöneticilerin oluşturduğu,'
                        ' günlük ve haftalık periyotlardaki market, manav, fırın ve diğer siparişlerini '
                        'görüntüleyebilir. Satın alım yaparken, ürünlerin fiyatlarını girerek kendisine ve sipariş sahibine '
                        'ödeme kısmında zaman kazandırarak, yanlış ödemeleri ortadan kaldırabilir. '
                        'Her katın ve dairenin çöp durumunu kontrol edebilir, çöp toplama zamanında yalnız çöpü olan '
                        'dairelere giderek zaman kazanabilir. '
                        'Apartman içi duyurulardan haberdar olup, yönetici tarafından '
                        'oluşturulan, apartman içi oylama etkinliklerine '
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
                        'Kapıcı, yukarıda gösterilen ve ekranın sağ üst kısmında bulunan '
                            'butonu kullanarak profil ekranına ulaşabilir. Sahip '
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
                        'Kapıcı, yukarıda gösterilen ve ekranın sağ üst kısmında bulunan '
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
                        'Kapıcı, yukarıda gösterilen ve ekranın sağ alt kısmında bulunan '
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

      // Kapıcı Alışveriş Modülü

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kapıcı, verilen siparişleri görüntülemek için ilk olarak ana ekrandan "Kapıcı İşlemleri" '
                        'butonuna, açılan sayfada "Kapıcıya Alışveriş Listesi" butonuna ve daha sonra da "Alım" '
                        'butonuna tıklamalıdır.',
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
                    '"Alım" ekranında kapıcı hangi alışveriş yerinde olduğuna göre'
                        '"Market", "Fırın", "Manav" ve "Diğer" seçeneklerinden birini seçer. Yer seçimi yapan kapıcı açılan sayfada, '
                        'seçilen yere göre alması gereken ürünler, ürünlerin adedi ve ürüne ait notları görüntüler. '
                        'Kapıcı bu sayfada aldığı ürünlerin birim fiyatlarını girmeli ve "Fiyatları Kaydet" butonuna tıklamalıdır.'
                        'Sayfadan çıkmak için "Kapat" butonuna tıklanır. Kapıcı bu şekilde sırasıyla bütün alışveriş yerlerindeki'
                        ' ürünleri görüntüleyip sırasıyla alıp fiyatlarını girmelidir.',
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
                    'Kapıcı, alınan ürünleri dağıtmak için ilk olarak ana ekrandan "Kapıcı İşlemleri" '
                        'butonuna, açılan sayfada "Kapıcıya Alışveriş Listesi" butonuna ve daha sonra da "Dağıtım" '
                        'butonuna tıklamalıdır.  ',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,color: Colors.green,),
                    SizedBox(height: 20),
                    Icon(Icons.close,color: Colors.red,),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"Dağıtım ekranında" kapıcı sipariş bekleyen dairelerin olduğu katların yanında "yeşil" işaret,'
                            ' sipariş bekleyen daire olmayan katları "kırmızı" işaretli olarak görüntüler. Ekranın en alt kısmında '
                            'kapıcı anlık bütçesini görebilir.',
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
                Icon(Icons.check_circle,color: Colors.green,),

                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sipariş bekleyen dairelerin olduğu kata tıklayan kapıcı, kattaki dairelerin listesini '
                            'görüntürler. Sipariş bekleyen daireler, yukarıda gösterilen ve her sipariş bekleyen dairenin'
                            'yanında bulunan yeşil işaretle diğer dairelerden ayrılır. Bir dairenin ekranına tıklandığında '
                            'o dairenin kapıcıyla olan anlık bütçe durumu görüntülenebilir.'
                            ' Siparişi olan dairenin butonuna tıklayınca,'
                            ' kapıcı sakine vermesi gereken ürünleri, adetlerini,'
                            'ürünlerin fiyatları, toplam sipariş ücretini görüntüler.',
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
                Icon(Icons.edit,color: Colors.red,),

                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Eğer kapıcı ürün yetersizliği nedeni ile siparişi eksik aldıysa, yukarıda gösterilen ve '
                            'ürün adedinin yanında bulunan butona tıklayarak kullanıcıya verdiği ürün adedini değiştirebilir. '
                            'Kapıcı değişikliği kayıt etmek için aynı butona tekrar tıklamalıdır.',
                        style: TextStyle(fontSize: 16),
                        softWrap: true, // Allow the text to wrap to the next line
                      ),
                    ),
                  ],
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
                    'Kapıcı siparişi teslim edince, sakinden aldığı ücreti "verilen tutar" boşluğuna yazıp "Bakiye Hesapla" '
                        'butonuna tıklarsa ekranın aşağısında bulunan "Bakiye" bölümünden anlık bakiyesini görüntüleyebilir. '
                        'Eğer sakinden eksik ücret aldıysa bu kısım "yeşil" renkte, eğer sonraki siparişler için de kullanmak için'
                        ' ekstra ücret aldıysa bu kısım "kırmızı" gözükür.',
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
                    '"Daire Siparişi" ekranının en alt kısmında bulunan "Teslim Et" butonuna basarak kapıcı teslim ettiği bilgisini'
                        ' uygulamaya işler. Bu daire artık kapıcıya siparişi yok olarak gösterilir.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),


          ],
        ),

      ),

      // Kapıcı Çöp Modülü

      const Expanded(
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kapıcı, apartman sakinlerinin ve yöneticilerinin çöp durumlarını görüntülemek için ilk olarak '
                        'ana ekrandan "Kapıcı İşlemleri" butonuna, daha sonra açılan sayfada "Çöp Takibi" butonuna tıklamalıdır.',
                    style: TextStyle(fontSize: 16),
                    softWrap: true, // Allow the text to wrap to the next line
                  ),
                ),
              ],
            ),

            Divider(),

            Column(
              children: [
                Icon(Icons.check_circle,color: Colors.green,),

                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"Çöp Takibi" ekranında kapıcı apartman katlarının listesini görüntüler. Çöpü olan dairelerin'
                            ' katlarının yanında yukarıda gösterilen "yeşil" işaret bulunur.',
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
                Icon(Icons.delete_forever,color: Colors.red,),

                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"Çöp Takibi" ekranında kapıcı, çöp olan katlardan birine tıkladığında o kattaki çöpü olan'
                            ' dairelerin listesini görüntüler. Kapıcı çöpü attıktan sonra, yukarda gösterilen ve listede her '
                            'dairenin yanında bulunan butona tıklayarak, ilgili dairenin çöpünü attığını uygulamaya işler. '
                            'Bu işlemden sonra sakin ve yöneticilere çöplerinin atıldığına dair bildirim gönderilir.',
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

    ],
  ];


  int? _expandedIndex;
  int? _nestedExpandedIndex;

  @override
  Widget build(BuildContext context) {
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

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          SizedBox(
            width: 130,  // Adjust the width as needed
            height: 60,  // Adjust the height as needed
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Bize Ulaşın'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min, // Adjusts the column to the size of its children
                        children: [
                          SizedBox(height: 10.0), // Adds spacing between texts
                          Text('Özlem Sevinç Ergül',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5.0), // Adds spacing between texts
                          Text('ozlemergul0@gmail.com'),
                          SizedBox(height: 10.0), // Adds spacing between texts
                          Text('Doğa Ünal',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5.0), // Adds spacing between texts
                          Text('doga.unal4635@gmail.com'),
                          SizedBox(height: 10.0), // Adds spacing between texts
                          Text('Duru Maye Acar',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5.0), // Adds spacing between texts
                          Text('duru.maye.acar@gmail.com'),
                          SizedBox(height: 10.0), // Adds spacing between texts
                          Text('Erdem Kılıç',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5.0), // Adds spacing between texts
                          Text('erdemkilic.iue@gmail.com'),
                          SizedBox(height: 10.0), // Adds spacing between texts
                          Text('Efe Furkan Aykut',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5.0), // Adds spacing between texts
                          Text('aykutefefurkan@gmail.com'),
                          // Add more Text widgets or any other widgets as needed
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: 'Bize Ulaşın',
              backgroundColor: Colors.teal,
              child: const Text(
                'Bize Ulaşın',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

          )



        ],

      ),
    );
  }
}
