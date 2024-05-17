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
  bool isTermsAccepted = false;

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
    return GestureDetector(
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
                style: greyTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
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
                            },
                          );
                        },
                        child: Text(
                          "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: phoneController.text.length > 9
                        ? Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: isTermsAccepted,
                    onChanged: (value) {
                      setState(() {
                        isTermsAccepted = value ?? false;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Kullanım Koşulları"),
                            content: const SingleChildScrollView(
                              child: Text(
                                'YAZILIM KULLANIM SÖZLEŞMESİ\n'
                                    '1.1. Bu sözleşme, Sağlayıcı “Orjin” ile “Kullanıcı” arasında, aşağıdaki koşulların tarafların özgür iradesi ile müzakere edilerek kabul edilmesi sonucu akdedilmiştir. Sağlayıcı, daha önce “Müşteri” ile akdetmiş olduğu “Lisans Kullanım Sözleşmesi” ile site yönetimi uygulaması olan “ApartCom” sistemi ile ilgili içerik ve lisansların kullanılması hizmetlerini sağlamayı taahhüt etmiştir. Sözleşmenin diğer tarafı olan Müşteri ise anılan sözleşme uyarınca kullanıcıları yetkilendirerek kullanıcıların sistem üzerinden sağlanan hizmetlerden yararlanmasını sağlamaktadır.\n'
                                    '1.2. Sağlayıcı Orjin tarafından, Müşteri ve kullanıcılara sunulan her türlü kullanım koşul ve kuralları bu sözleşmenin ayrılmaz bir parçası olup bu sözleşmedeki hak ve yükümlülüklerle birlikte tarafların hak ve yükümlülüklerinin tamamını oluşturmaktadır.\n'
                                  '1.3. Bu sözleşmenin konusu, Kullanıcı’nın sistemden yararlanmasına ilişkin hüküm ve koşulların ortaya konularak tarafların hak ve yükümlülüklerinin belirlenmesidir.\n'
                                  '1.4. Sağlayıcı, bu sözleşmeye uygun olarak Kullanıcı’ya sistemi kullandırmayı ve hizmet sağlamayı taahhüt eder; buna karşılık Kullanıcı, sistemi kullanırken sözleşme bütünlüğü çerçevesindeki tüm hüküm ve koşullara uymayı taahhüt eder.\n'

                              '1.5. Kullanıcı, sözleşmenin hüküm ve koşullarını kısmen ya da tamamen kabul etmiyorsa; sisteme kayıt olmamalı, kayıt olmuş ise sisteme giriş yapmamalı ve hesabını kapatmalıdır. Aksi bir durum, yani sistemin kullanılması ya da hesabın kapatılmaması hali, Kullanıcı’nın sözleşme bütünlüğü çerçevesinde sistemi kullanmayı kabul ettiğine karine teşkil eder.\n'

                             ' 2. TARAFLAR\n'

                                  '2.1. Hizmeti sağlayan (Sağlayıcı), hizmetten yaralanan (Orjin) dir. Bundan böyle “Orjin” ya da “Sağlayıcı” olarak anılacaktır.\n'
                              '2.2. Hizmeti alan, bu sözleşmedeki hükümleri kabul eden, hizmet sözleşmesine dayalı olarak Müşteri tarafından kendisine onay/yetki verilen, sistemi kullanacak kat maliki, sınırlı ayni hak sahibi, kiracı, alt kiracı, her türlü kat sakini, personel vb. gerçek ya da tüzel kişilerdir. Bundan böyle “Kullanıcı” olarak anılacaktır.\n'
                          '2.3. “Orjin” ya da “Sağlayıcı” ile “Kullanıcı” bu sözleşmede tek başlarına “Taraf” birlikte ise “Taraflar” olarak anılacaktır.\n'

                          '3. TANIMLAR\n'
                          '3.1. Sağlayıcı; sözleşme konusu hizmeti sağlayan,\n'
                                '3.2. Orjin,\n'
                                ' 3.3. ApartCom; Sağlayıcı tarafından oluşturulan alan adında ve alt alan adlarında faaliyet gösteren ya da bu adreslere yönlendirilmiş alan adları ile internet sitesi üzerinden Müşteri ve kullanıcıların hizmetine sunulan her türlü yazılım, içerik, mobil uygulama vb. hizmeti içeren sistemi;\n'
                                '3.4. Uygulama; ApartCom mobil uygulamasını;\n'
                                '3.5. Sistem; ApartCom uygulaması ile ilişkili tüm unsurları;\n'
                                '3.6. Müşteri; Sağlayıcı tarafından sunulan hizmetlerden yararlanmak amacıyla bir hizmet bedeli karşılığında Sağlayıcı ile “Lisans Kullanım Sözleşmesi” akdeden, böylelikle sistemi kullanacak son kullanıcıların (malik, kiracı, sınırlı ayni hak sahibi vb. herhangi bir şekilde kendilerince yetkilendirilen gerçek ya da tüzel kişilerin) ilişkili olduğu toplu yaşam alanlarında 634. Sayılı Kat Mülkiyeti Kanunu’na göre atanmış yönetici ya da yönetim kurulunu;\n'
                                '3.7. Yönetim; Sağlayıcı ile akdedilen Lisans Kullanım Sözleşmesi’nin karşı tarafı olan Müşteri’yi yani toplu yaşam alanlarında 634. Sayılı Kat Mülkiyeti Kanunu’na göre atanmış yönetici ya da yönetim kurulunu;\n'
                                '3.8. Personel; genellikle Müşteri’nin çalışanı olan, Müşteri tarafından Lisans Kullanım Sözleşmesi çerçevesinde sistemi kullanması için yetkilendirilen ya da bir şekilde Müşteri vasıtasıyla sistemi kullanabilen, sözleşmede Müşteri için belirlenen her türlü sorumluluk ve kullanım koşullarına aynı derecede bağlı kişileri;\n'
                                '3.9. Yetkili Kişi; Sağlayıcı ile iletişimi sağlaması amacıyla Lisans Kullanım Sözleşmesi çerçevesinde Müşteri tarafından yetkilendirilmiş kişiyi;\n'
                                '3.10. Kullanıcı; işbu sözleşmeye dayalı olarak, Müşteri tarafından Lisans Kullanım Sözleşmesi çerçevesinde kendisine onay/yetki verilen, sistemi kullanacak kat maliki, sınırlı ayni hak sahibi, kiracı, alt kiracı, her türlü kat sakini vb. kişileri;\n'
                                '3.11. Hizmet; 634 sayılı Kat Mülkiyeti Kanunu kapsamında yönetilen apartman, site, avm, apart, plaza, işhanı, ofis alanı gibi toplu yaşam alanları için Sağlayıcı tarafından oluşturulan uygulama ve sistemin kullanım hakkını;\n'
                                '3.12. Mücbir Sebep; sözleşme akdedildiği tarihte öngörülmesi olanaklı olmayan, tarafların irade ve davranışlarından bağımsız olarak gelişen, tarafların sözleşme ile yüklendikleri borç ve sorumlulukları kısmen ya da tamamen yerine getirmelerini olanaksız hale getiren her türlü doğal afet, savaş, seferberlik, yangın, sel, su baskını, grev ve lokavt veya hükümet yahut resmi makamlarca alınmış kararlar ile alt yapı sorunları, telefon ve internet şebekelerindeki arızalar, elektrik kesintileri veya benzeri halleri;\n'
                                '3.13. Beklenmeyen Hal; sözleşme ilişkisinde Sağlayıcı’nın, irade ve davranışından bağımsız olarak borcunu ihlal etmesine kaçınılmaz biçimde neden olan olay ve durumları;\n'
                                '3.14. Ziyaretçi; ApartCom sistemini incelemek amacıyla sistemi ziyaret eden üçüncü kişileri;\n'
                                '3.15. Taraf; tek başına Sağlayıcı yani Orjin Ltd. ile Müşteri’yi;\n'
                                '3.16. Taraflar; Sağlayıcı ve Kullanıcı’yı birlikte;\n'
                                '3.17. Sözleşme; Sağlayıcı ve Kullanıcı arasında yapılan işbu kullanıcı sözleşmesi ile sözleşme bütünlüğü çerçevesinde tüm eklerini;\n'
                                '3.18. Lisans Kullanım Sözleşmesi; Sağlayıcı ile Müşteri arasında yapılan sözleşme ile sözleşme bütünlüğü çerçevesinde tüm eklerini;\n'
                                '3.19. Personel Kayıt Formu; Müşteri’nin Personel olarak yetki verdiği tüm kişilerin ve/veya temsilcilerinin gerekli bilgilerinin yer aldığı, yazılı ya da sistem üzerindeki çevrimiçi formu;\n'
                                '3.20. Teklif Önerisi; Sağlayıcı tarafından sözleşme görüşmeleri sırasında ya da Lisans Kullanım Sözleşmesi ekinde Müşteri’ye sunulan, sözleşme bütünlüğü çerçevesinde Lisans Kullanım Sözleşmesi’nin bir parçası olan; sözleşme süresi, hizmet bedeli, kampanya vb. bilgi ve teklifler ile Müşteri’nin onayına sunulan çeşitli hususları da içerebilen; sayesinde Müşteri’nin kendisine sunulan tekliflerden birini seçebildiği, Sağlayıcı ile müzakere olanağı yakaladığı, kendisine sunulan hususlarda açık onay verebildiği ya da vermediği formu;\n'
                                '3.23. Tebligat Adresi; Sağlayıcı bakımından işbu sözleşmede yer alan adresi, Kullanıcı bakımından ise bu sözleşme ve eklerinde beyan edilen ya da sistem üzerine girilen adresi;\n'

                                '4. SÖZLEŞMENİN BÜTÜNLÜĞÜ\n'

                                    '4.1. Bu sözleşmede düzenlenen hak ve yükümlülüklerin yanında;\n'
                                '4.1.1. Sağlayıcı ile Müşteri arasında yapılan ve sistem üzerinden ulaşılabilen Lisans Kullanım Sözleşmesi’nin Kullanıcı’yı ilgilendiren tüm hak ve yükümlülükleri;\n'
                                '4.1.2. Sağlayıcı’nın sistem ve bağlantılı tüm unsurları üzerinden kullanıma ilişkin sunduğu kurallar, Kullanıcı’ya yönelik duyurular, gönderilen eposta, mesaj, bildirim gibi her türlü iletiler sözleşmenin bütünlüğünü oluşturur.\n'
                                '4.2. Kullanıcı, sözleşme bütünlüğü kavramını anladığını, sözleşmenin bütünlüğü çerçevesinde kendisini ilgilendiren tüm hüküm ve koşullara uyacağını kabul ve taahhüt eder.\n'

                                '5. SÖZLEŞME SÜRESİ\n'

                                    '5.1. Sözleşme süresi, Sağlayıcı ile Müşteri arasında yapılan Lisans Kullanım Sözleşmesi bağlamında belirlenmektedir. Müşteri’nin Lisans Kullanım Sözleşmesi akdedilirken Teklif Önerisi vasıtasıyla ya da başka bir şekilde belirlenmiş olan sözleşme süresi Kullanıcı’yı da bağlar. Lisans Kullanım Sözleşmesi’nin yenilenmesi, hangi sebeple olursa olsun sona ermesi işbu sözleşmeye de sirayet eder.\n'
                                '5.2. Kullanıcı, Lisans Kullanım Sözleşmesi geçerli olduğu sürece ve aksini gerektiren başka bir durum olmadığı sürece Sağlayıcı tarafından sunulan hizmetten yararlanmaya devam eder.\n'
                                '5.3. İşbu sözleşmenin yenilenmeden önce Sağlayıcı tarafından revize edilmesi ve bunun sistem üzerinden ya da Müşteri’ye eposta göndermek suretiyle duyurulması durumunda, yeni dönemde revize edilmiş sözleşme hükümleri geçerli olacaktır.\n'

                                '6. HİZMET KULLANIM KOŞULLARI\n'

                                '6.1. Hizmeti sağlayan Sağlayıcı, sistemin sahibidir. Sistemde yer alan her türlü içeriği, kullanım koşullarını Kullanıcı’ya bildirimde bulunmaksızın değiştirme hakkına sahiptir.\n'
                                '6.2. Kullanıcı, sözleşmeyi imzalamakla; henüz imzalamamakla birlikte kendisine Müşteri tarafından yetki verilmesi sonucu sisteme ilk kez giriş yapmakla, sistemi kullanma hakkını satın almakla, sistem üzerinden kayıt oluşturmakla, kayıt formunu doldurarak Müşteri ya da Sağlayıcı’ya ulaştırmakla veya bir şekilde kullanıcı statüsü kazanmakla ya da sistemi kullanmakla işbu kullanıcı sözleşmesi ile her nevi ekini okumuş ve tüm hüküm ve koşullarını kabul etmiş sayılır. Kullanıcı, işbu sözleşmede ıslak imzası olmamasından dolayı sözleşme ile getirilen yükümlülüklerinden kurtulamaz.\n'
                                '6.3. Kullanıcı hukuki işlemlerde bulunma bakımından tam ehliyetli olduğunu kabul ve beyan eder.\n'
                                '6.4. Kullanıcı, bir kullanım koşulunun Sağlayıcı tarafından sistemde ilan edilmekle yürürlük kazanacağını bildiğini peşinen kabul eder.\n'
                                '6.5. Sağlayıcı, herhangi bir sebep göstermeksizin ya da herhangi bir şekilde bildirimde bulunmaksızın sözleşmenin bütünlüğünü oluşturan herhangi bir hüküm ya da koşulu değiştirebilir, kaldırabilir, revize edebilir; ek hüküm ve koşullar oluşturabilir; gerektiği durumlarda herhangi bir açıklama yapmaksızın hizmeti geçici ya da kalıcı şekilde askıya alabilir.\n'
                                '6.6. Kullanıcı, sistemi kullanmak amacıyla edindiği kullanıcı adı ve şifresini korumakla yükümlüdür. Kullanıcı adı, şifresi ve hesabını kullanmaya yarayan her türlü bilginin yönetiminden kullanıcı sorumludur. Kullanıcı, tüm bu bilgileri hiçbir koşulda üçüncü kişiler ile paylaşamaz, üçüncü kişilerin sisteme gireceği olanak ve ortamları oluşturamaz. Kullanıcı, bilgilerini koruma yükümlülüğü olduğundan dolayı bu yükümlülüğün ihlalinden sorumludur. Sisteme kullanıcı adı ve şifresiyle işlem yapılmasından bizzat sorumludur. Şifre ve kullanıcı adının üçüncü kişilerin eline bir şekilde geçmesi halinde derhal Sağlayıcı’ya bilgi vermek zorundadır. Bu durumda Sağlayıcı, erişim engelleme ya da üyeliğinin sona erdirilmesi de dahil olmak üzere her türlü önlemi alabilir. Kullanıcı, bilgi verme yükümlülüğünün ihlalinden ya da bilgi vermede gecikmeden dolayı sorumludur. Bu sorumluluk yalnızca Sağlayıcı’ya yönelik değil; Kullanıcı aynı zamanda üçüncü kişilere vermiş olduğu zararlardan da sorumludur.\n'
                                '6.7. Kullanıcı, sisteme girdiği her türlü bilgi ve içerikten bizzat sorumludur. Kullanıcı, sisteme doğru, gerçek ve eksiksiz bilgi ve içerik girmek durumundadır. Sağlayıcı’nın bu bilgi ve içeriği kontrol etme yükümlülüğü yoktur. Sağlayıcı, bilgi ve içeriğin uygun olmadığını düşünüyorsa, Kullanıcı’dan bunun kaldırılmasını isteyebileceği gibi kendisi de her türlü müdahale hakkına sahiptir. Kullanıcı, Sağlayıcı’nın müdahale hakkını peşinen kabul eder. Kullanıcı, girmiş olduğu bilgi ve içerikten dolayı Sağlayıcı ya da üçüncü kişilere doğrudan ya da dolaylı bir zarar vermiş ise, tüm zararı karşılamayı, peşinen kabul ve taahhüt eder. Söz konusu zarar bir şekilde Sağlayıcı tarafından karşılanmışsa, Kullanıcı, yapılan ödemenin yanı sıra sözleşmesel vekalet ücreti de dahil olmak üzere Sağlayıcı’nın yapmış olduğu tüm yargılama giderleri ile uğradığı zararları ve ödemenin yapıldığı andan itibaren işleyecek yasal faizi herhangi bir ihtara gerek kalmaksızın ödemekle yükümlüdür.\n'
                                '6.8. Sağlayıcı, sisteme yüklenen veri ve içeriği Lisans Kullanım Sözleşmesi, Kullanıcı Sözleşmesi, Aydınlatma metni ve 6698 sayılı KVKK kapsamında kullanabilir. Açık rızanın gerekli olduğu durumlarda; Sağlayıcı, sistem üzerinden açık rızayı alabilir. Hizmetin sağlanması için gerekli olan isim, adres ve iletişim bilgileri ile Kullanıcı’ya ait hesap bilgileri Sağlayıcı tarafından kullanılabilir ve saklanabilir.\n'
                                '6.9. Kullanıcı, sisteme yüklediği bilgi ve içeriğin kaldırılmasını ya da saklanmamasını talep edebilir. Bu talebini doğrudan Sağlayıcıya yapabilir. Böyle bir talep Sağlayıcı’ya yazılı olarak ulaşmadığı sürece, söz konusu içeriğin sistemden kaldırılmamasından ya da saklanmasından Sağlayıcı sorumlu değildir.\n'
                                '6.10. Kullanıcı’ya Sağlayıcı tarafından işbu sözleşme kapsamında sağlanan tüm hizmetler, temel olarak Sağlayıcı ile Müşteri arasında akdedilen Lisans Kullanım Sözleşmesi bağlamında sunulmaktadır. Sağlayıcı, 5651 sayılı Yasa uyarınca hizmet ve içerikleri barındıran sistemleri sağlayan veya işleten gerçek veya tüzel kişileri ifade eden “yer sağlayıcı” sıfatını haizdir. Sağlayıcı, sisteme kendisinin dışında girilen hiçbir içerik bakımından sorumlu değildir. Sağlayıcı’nın yükümlülükleri 5651 sayılı Yasa’nın 5. maddesi kapsamı ile sınırlıdır. Kullanıcı bunu peşinen kabul eder.\n'
                                '6.11. Kullanıcı, sistemi kullanırken sözleşme bütünlüğü çerçevesinde öngörülen tüm kurallara, her türlü yasal mevzuata uyacağını kabul ve beyan eder. Kullanıcı, sistemi ahlak ve adaba, dürüstlük kuralına, komşuluk hukukuna saygılı biçimde, üçüncü kişilerin her türlü kişilik haklarını ihlal etmeksizin kullanacağını kabul ve beyan eder. Aksi bir kullanım biçiminden doğacak sorumluluğa katlanır. Kullanıcı, sisteme yüklenen ya da sistemde yer alan tüm içeriğin sözleşme hükümlerine, yürürlükteki mevzuata uygun olacağını, sistemin hiçbir unsurunu kullanarak hakaret, tehdit, taciz, korkutma, iftira gibi konusu suç olan, uygunsuz, müstehcen ya da cinsel içerikli yahut nefret söylemi amaçlı paylaşımlarda bulunmayacağını, böyle bir durumu fark ettiği anda gerekli önlemleri alacağını, derhal Sağlayıcı’yı bilgilendireceğini, Sağlayıcı’nın sunduğu sistemin herhangi bir iletişim kanalı üzerinden dile getirdiği her türlü fikir, düşünce, ifade, yorum ve yazıların kendisine ait olduğunu, bunlara ilişkin olarak Sağlayıcı’nın bir sorumluluğunun bulunmadığını kabul ve taahhüt eder.\n'
                                '6.12. Kullanıcı, Sağlayıcı’nın sunduğu hizmet ve sistem ile bağlı tüm unsurlarına zarar verecek, bunların çalışmasına olumsuz etki edecek, işleyişini engelleyecek şekilde davranışlardan kaçınacağını taahhüt eder. Bu bağlamda Kullanıcı, üçüncü kişilere sistem unsurlarını kullanılarak siber saldırı düzenleyemeyeceği gibi üçüncü kişilerin kişisel verilerini toplayamaz ve kullanamaz. Sistem ve tüm unsurlarının çalışmasını etkilemek amacıyla herhangi bir yazılım, yöntem, donanım ve aracı kullanamaz. Sisteme virüs, trojan vb. kötü, kirletici ya da bozucu yazılım içeren dosya ve içerik yükleyemez. Bu maddeden dolayı sorumluluk Kullanıcı’ya ait olup Sağlayıcı’nın hiçbir sorumluluğu bulunmamaktadır.\n'
                                '6.13. Sistemi kullanımdan doğan her türlü hukuki ve cezai sorumluluk Kullanıcı’ya aittir. Sağlayıcı’nın gerek Kullanıcı’ya gerekse zarar gören üçüncü kişilere karşı herhangi bir sorumluluğu bulunmamaktadır.\n'
                                '6.14. Sağlayıcı reklam içeren içerikleri Sağlayıcı’nın bilgi ve yazılı onayı olmaksızın sisteme yükleyemez.\n'
                                '6.15. Sağlayıcı gerekli gördüğü durumlarda, sistem ve unsurlarında geliştirme ve güncellemeler yapabilir. Kullanıcı, bu süreçteki aksaklıklara katlanmak durumundadır.\n'
                                '6.16. Sağlayıcı; uygun koşulların varlığına bağlı olarak hizmeti sunabilir. İnternet ya da servis sağlayıcıları gibi Sağlayıcı’nın kontrolü dışındaki unsurların hizmetin kalitesini etkilemesi olanaklıdır. Sağlayıcı’nın kasıtlı davranışı ve ağır kusuru dışında oluşan teknik aksaklıklardan Sağlayıcı’nın sorumluluğu bulunmamaktadır.\n'
                                '6.17. Sistem üzerinden başka internet sitesi ya da sistemlere bağlantılar oluşturulabilir. Bu bağlantılar aracılığıyla ulaşılan web sitesi, dosya veya sistemlerin içeriğinden Sağlayıcı sorumlu değildir.\n'

                                ' 7. TARAFLARIN SORUMLULUĞU\n'

                                    '7.1. Sağlayıcı, sunmuş olduğu hizmetin kalitesinin belirli bir düzeyde olacağına ilişkin garanti vermez. Hizmetin kalitesinin belirli bir düzeyde olmadığından bahisle Kullanıcı’ya karşı sorumluluğu bulunmamaktadır.\n'
                                '7.2. Kullanıcı, hizmeti sözleşme akdedildiği sırada nasıl ise o şekilde (olduğu gibi) kabul eder. Sağlayıcı’nın Kullanıcı iyileştirme ve geliştirme taleplerini yerine getirme zorunluluğu bulunmamaktadır.\n'
                                '7.3. Sağlayıcı, gerekli gördüğü takdirde hizmeti askıya alabilir, Kullanıcı’nın hesabını bloke edebilir. Bu sebeple Kullanıcı’ya karşı sorumluluğu bulunmamaktadır.\n'
                                '7.4. Mücbir sebep, beklenmeyen hal ya da Sağlayıcı’nın kasıtlı davranışı ile oluşmayan diğer sebeplerden dolayı oluşacak zarar sebebiyle Sağlayıcı sorumlu tutulamaz. Anılan durumlarda Sağlayıcı yükümlülüklerini hiç ifa edemeyebileceği gibi geç ifa da edebilir.\n'
                                '7.5. Sağlayıcı, ağır kusur ve kasıtlı davranışı dışında bu sözleşme çerçevesinde doğan zararlardan hiçbir şekilde sorumlu değildir.\n'
                                '7.6. Sağlayıcı; sistemdeki verilerin silinmesi, sistemin siber saldırıya uğraması, virüs vb zararlı program ve uygulamalar sebebiyle çalışamaz hale gelmesi, hırsızlık vb. haksız fiiller sonucu sistemin zarar görmesi, verilerinin kullanılamaz hale gelmesi, iletişimin kesilmesi gibi sebeplerle bir şekilde hizmetin gereği gibi devamının olanaklı hale gelmemesinden dolayı sorumlu değildir.\n'
                                '7.7. Kullanıcı, sistem üzerinden paylaştığı içerikten dolayı bizzat sorumludur. Sağlayıcı’nın Kullanıcı tarafından paylaşılan içerikten dolayı herhangi bir sorumluluğu bulunmayacağı gibi bu içeriğin doğruluğunu, hukuka uygunluğunu, gerçekliğini denetlemek durumunda değildir. Ancak kendisine yazılı bir bildirim yapıldığı takdirde, bu içeriğin kaldırılması ve ilgili hesapların bloke edilmesi gibi her türlü önlemi alma hakkına sahiptir.\n'

                                '8. SIR SAKLAMA ve GİZLİLİK HÜKÜMLERİ\n'

                                '8.1. Tarafların, bu sözleşme kapsamında edindikleri her türlü bilgi ve belge; sözleşme süresince ve sözleşme sona erdikten sonra gizlilik bildirimi kapsamındadır. Kural olarak ilgili tarafın rızası ya da onayı olmaksızın üçüncü kişilerle paylaşılamaz.\n'
                                '8.2. Sisteme Kullanıcı tarafından girilen veri ve içerik Kullanıcı’ya aittir.\n'
                                '8.3. Sağlayıcı, Kullanıcı tarafından girilen veri ve içeriği mevzuata uygun şekilde korur.\n'
                                '8.4. Kullanıcı, sisteme girdiği bilgi ve belgelere sözleşme süresince erişebilir. Sağlayıcı’nın işbu sözleşme uyarınca erişim engeli koyduğu durumlar saklıdır. Sağlayıcı’nın kasıtlı davranışı ya da ağır kusuru dışındaki bir sebep ile Müşteri’nin sisteme erişememesi durumundan dolayı Sağlayıcı sorumlu tutulamaz.\n'
                                '8.5. Sağlayıcı, Kullanıcı’ya ait bilgileri Kullanıcı’nın onayı olmaksızın üçüncü kişilerle paylaşamaz. Sağlayıcı, Kullanıcı’ya dış iş ortaklarından çeşitli teklif vb. için ileti almayı isteyip istemediklerini sorabilir; bunu bir seçenek olarak sunabilir.\n'
                                '8.6. Kullanıcı, sisteme giriş şifresini gizli tutmak ve korumak zorundadır. Ortak ortamlardan ve aygıtlardan erişim sağlandığında, oturumun mutlaka sonlandırılması, şifre kaydedici ya da hatırlatıcı uygulamaların kullanılmaması gerekir. Kullanıcı, şifresini korumak zorunda olduğunu, bu özen yükümlülüğüne aykırı hareket etmesi dolayısıyla oluşacak her türlü zarardan dolayı kusuru olmasa dahi sorumlu olacağını kabul ve taahhüt eder.\n'
                                '8.7. Sağlayıcı, Kullanıcı’nın bilgilerini yetkisiz erişime ve kullanıma karşı korumak için gerekli özeni gösterir.\n'
                                '8.8. Sağlayıcı, işbu sözleşme ile verilen hizmeti, Müşteri’nin ismi, logosu, unvanı, markası gibi özelliklerini de kullanarak üçüncü kişilere karşı referans olarak gösterebilir, her türlü platformda reklam unsuru olarak kullanabilir.\n'
                                '8.9. Kullanıcı’ya ait bilgiler; mevzuat gereği, mahkeme kararı ya da idarenin talebiyle açıklanabilir, üçüncü kişi ya da kurumlar ile paylaşılabilir. Bu durumda Sağlayıcı’nın sorumluluğuna gidilemez. Bu sebeple Sağlayıcı’dan herhangi bir tazminat talebinde bulunulamaz.\n'
                                '8.10. Sağlayıcı, hizmet kalitesini artırmak ve böylelikle daha etkin hizmet sunabilmek amacıyla Kullanıcı’dan ek bilgiler talep edebilir.\n'
                                '8.11. Sağlayıcı, sisteme erişimi olan tüm kişilerin; yani Müşteri, Personel, Kullanıcı ya da Müşteri tarafından yetki verilen diğer kişilerin IP adreslerini kayıt altında tutabilir. Sağlayıcı, bu bilgileri gizli tutar. Yasal zorunluluklar saklıdır. Kullanıcı bu durumu kabul eder ve onaylar.\n'
                                '8.12. Sistem, tüm unsurlarıyla birlikte Sağlayıcı’ya aittir ve ona ait bir telif hakkı oluşturur. Sağlayıcı, sistemi kullanması bakımından Kullanıcı’ya izin vermiştir. Ancak Kullanıcı’nın olanak tanıması veya yetki vermesi ya da yetki vermeksizin üçüncü kişilerin bir şekilde Kullanıcı’nın hesabından sisteme erişimleri, sistemin kaynak kodlarını almaları, sistemden kopya, ekran görüntüsü vb. almaları Kullanıcı’nın sorumluluğunda olup Kullanıcı, üçüncü kişilerin telif hakkı ihlallerinden dolayı sorumlu olduğunu kabul ve beyan eder.\n'
                                '8.13. Sağlayıcı; Kullanıcı’nın verilerini, sistemi Kullanıcı’ya göre özelleştirmek amacıyla işleyebilir. Kullanıcı, KVKK çerçevesinde veri işlemesi bakımından Sağlayıcı’yı yetkilendirdiğini kabul ve beyan eder.\n'
                                '8.14. Sağlayıcı, Kullanıcı’nın verilerini KVKK’ya uygun şekilde işler.\n'
                                '8.15. Sözleşme sırasında ya da sona erdikten sonra bir şekilde silinen ya da değiştirilen veriler, Kullanıcı tarafından yazılı olarak talep edilmesi halinde, şayet teknik olarak olanaklı ise yeniden Sağlayıcı tarafından sisteme yüklenebilir. Sağlayıcı, bu işlem karşılığında belirlediği bir bedeli Kullanıcı’dan talep edebilir.\n'
                                '8.16. Banka ve hizmet sağlayıcı kurumlar ile yapılacak uyum sürecinde, Sağlayıcı’nın sorumluluğu teknik altyapıyı hazırlayarak Kullanıcı’nın banka ve hizmet sağlayıcılarından alınan hesap hareketlerini ve verileri sisteme aktararak Müşteri’nin kullanıma sunmak ve sistemin güvenliğini sağlamaktır. Kullanıcı, banka nezdindeki tüm verilerinin sisteme aktarılmasını peşinen kabul eder.\n'

                                '9. FİKRİ MÜLKİYET HAKLARI\n'

                                '9.1. Sistemin yani ApartCom ile bağlantılı tüm unsurlarının, www.apartsoft.com web sitesinin tüm içerik, yazılım ve donanımı Sağlayıcı’ya aittir ve fikri ve sınai mülkiyet hukukuna ilişkin Sınai Mülkiyet Kanunu, Fikir ve Sanat Eserleri Kanunu ve ilgili mevzuat kapsamında korunmaktadır.\n'
                                '9.2. Kullanıcı, kural olarak Sağlayıcı tarafından sunulan hizmet ve sisteme, Lisans Kullanım Sözleşmesi çerçevesinde yazılım ürününün münhasır olmayan kullanım lisansının sahibi olan Müşteri’nin (Yönetim’in) yetki tanıması suretiyle erişebilir. Sistemi bu lisans çerçevesinde ve Sağlayıcı ile Müşteri tarafından belirlenen kurallar dahilinde kullanabilir. Bunun dışındaki tüm fikri ve sınai mülkiyet hakları Sağlayıcı’ya aittir.\n'
                                '9.3. Sağlayıcı, üçüncü kişi geliştiricilere alt lisans tanıyabilir.\n'
                                '9.4. Kullanıcı sistemin işleyiş ve güvenliğine tehdit oluşturabilecek, fikri sınai mülkiyet haklarını ihlal edebilecek her türlü işlem, eylem ve davranıştan kaçınır.\n'
                                '9.5. Kullanıcı tarafından sisteme yüklenen her türlü içeriğin başkalarının fikri ve sınai mülkiyet haklarını ihlal etmemesi gerekir. Bu içerikler, mülkiyeti Müşteri’deyse ya da bu hakkın sahibinin yazılı izni söz konusuysa sisteme yüklenebilir. Kullanıcı’nın, özellikle üçüncü kişilerin telif haklarına, kişilik haklarına, özel hayatın gizliliğine saygılı olması, bu hakları ihlal etmemesi gerekir. Bu şekilde bir ihlalden dolayı Sağlayıcı’nın sorumluluğu bulunmamaktadır. Sağlayıcı, bu tür ihlalleri öğrendiğinde, müdahale etme, içeriği kaldırma ve gerekli gördüğü başkaca önlemlere başvurma hakkını saklı tutar.\n'
                          '9.6. Kullanıcı, sistemi ve tüm unsurlarını, buna bağlı olarak web sitesi ve uygulamayı amacı dışında kısmen ya da tamamen kopyalayamaz, türevlerini oluşturamaz, ters mühendislik yapamaz, işleme eser oluşturamaz; kaynak kodlarını alamaz, kopyalayamaz, değiştiremez ve kullanamaz. Kullanıcı, sayılanlar dışında burada sayılmayan ve fakat hukuka aykırı şekilde fikri ve sınai mülkiyet haklarına aykırı işlem, eylem ve davranışlarda da bulunamaz.\n'
                          '9.7. Kullanıcı, Sağlayıcı’nın ticaret unvanını, logosunu, markalarını ve diğer tüm fikri ve sınai mülkiyet haklarını korumakla yükümlüdür. Bunları Sağlayıcı’nın yazılı izin olmaksızın kullanamaz.\n'
                          '9.8. Sağlayıcı, Kullanıcı’nın fikri mülkiyet hukuku kapsamı da dahil olmak üzere üçüncü kişilere yönelik hak ihlallerinin kendisine yöneltilmesi durumunda, bu talepleri Kullanıcı’ya yöneltir. Sağlayıcı’nın bu ihlaller sebebiyle sorumluluğu bulunmamaktadır.\n'

                          '10. SÖZLEŞMENİN FESHİ\n'

                          '10.1. Kullanıcı, herhangi bir bildirimde bulunmaksızın sistem üzerinden üyeliğine son verebilir.\n'
                          '10.2. Kullanıcı’nın, toplu yaşam alanını ile ilişkisinin kalmaması durumunda sisteme girişimi kısıtlanabilir ya da engellenebilir. Kullanıcı, böyle bir durumda sistem üzerinden üyeliğine son vermeli ya da derhal Sağlayıcı’yı bilgilendirmek zorundadır.\n'
                          '10.3. Sağlayıcı, Kullanıcı’nın işbu sözleşme ve sözleşme bütünlüğü çerçevesinde öngörülen hüküm ve koşullara uymaması durumunda Kullanıcı’ya ait hesabı dondurabilir, askıya alabilir, sisteme girişimi kısıtlanabilir ya da engellenebilir. Sağlayıcı, bu durumda sözleşmeyi fesih hakkına sahiptir.\n'

                          '11. DİĞER HÜKÜMLER\n'

                          '11.1. İşbu sözleşmeden doğacak tüm uyuşmazlıklar bakımından İstanbul Anadolu Mahkemeleri ve İcra Daireleri yetkilidir.\n'
                          '11.2. İşbu sözleşmeden doğacak tüm uyuşmazlıklar, Türk hukukuna tabidir.\n'

                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Kapat"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Kullanım Koşullarını kabul ediyorum",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: isTermsAccepted ? sendPhoneNumber : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
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
          child: const Icon(
            Icons.question_mark,
            color: Colors.white,
          ),
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
