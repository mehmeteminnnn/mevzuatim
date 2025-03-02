import 'package:cloud_firestore/cloud_firestore.dart';

class BlogYorum {
  final String kullaniciAdi;
  final Timestamp tarih;
  final String yorum;

  BlogYorum({required this.kullaniciAdi, required this.tarih, required this.yorum});

  // Firestore'dan veri çekildiğinde, gelen veriyi BlogYorum nesnesine dönüştürme
  factory BlogYorum.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlogYorum(
      kullaniciAdi: data['kullanici_adi'] ?? '',
      tarih: data['tarih'] ?? Timestamp.now(),
      yorum: data['yorum'] ?? '',
    );
  }

  // Firestore'a veri eklemek için, BlogYorum nesnesini bir Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'kullanici_adi': kullaniciAdi,
      'tarih': tarih,
      'yorum': yorum,
    };
  }

  // Tarih formatını istediğiniz şekilde dönüştürmek için bir yardımcı metod ekleyebilirsiniz
  String get formattedDate {
    return "${tarih.toDate().day}-${tarih.toDate().month}-${tarih.toDate().year} ${tarih.toDate().hour}:${tarih.toDate().minute}";
  }
}
