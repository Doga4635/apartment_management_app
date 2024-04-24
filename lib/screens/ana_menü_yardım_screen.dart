import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yardım'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_helpText),
        ),
      ),
    );
  }
}