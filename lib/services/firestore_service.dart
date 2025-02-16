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
}
