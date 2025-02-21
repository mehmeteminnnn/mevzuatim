import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mevzuatim/models/blog_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Blog koleksiyonundan manset field'ı "Düşünceleriniz" olan blogları al
  Future<List<BlogModel>> getBlogsByManset(String mansetValue) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('blog') // Koleksiyon adı
          .where('manset',
              isEqualTo: mansetValue) // manset alanına göre filtrele
          .get();

      // BlogModel'e dönüştür ve liste olarak döndür
      List<BlogModel> blogs = snapshot.docs
          .map((doc) => BlogModel.fromFirestore(doc)) // fromFirestore kullan
          .toList();

      return blogs;
    } catch (e) {
      throw Exception('Bloglar alınamadı: $e');
    }
  }

  Future<String?> getUserNameFromEmail(String email) async {
  // Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Kullanıcılar koleksiyonunda mail ile eşleşen kullanıcıyı arıyoruz
    QuerySnapshot userSnapshot = await firestore
        .collection('kullanıcılar')
        .where('mail', isEqualTo: email)
        .get();

    if (userSnapshot.docs.isEmpty) {
      print("User not found");
      return null;
    }

    // Eşleşen kullanıcıyı bulduk, kullanıcı adını alıyoruz
    String userName = userSnapshot.docs.first['kullanici adi'];

    return userName;
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

Future<String?> getUserRoleFromEmail(String email) async {
  // Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Kullanıcılar koleksiyonunda mail ile eşleşen kullanıcıyı arıyoruz
    QuerySnapshot userSnapshot = await firestore
        .collection('kullanıcılar')
        .where('mail', isEqualTo: email)
        .get();

    if (userSnapshot.docs.isEmpty) {
      print("User not found");
      return null;
    }

    // Eşleşen kullanıcıyı bulduk, kullanıcının yetki bilgisini alıyoruz
    String userRole = userSnapshot.docs.first['yetki'];

    return userRole;
  } catch (e) {
    print("Error: $e");
    return null;
  }
}



}
