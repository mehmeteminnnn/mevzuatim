import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mevzuatim/models/blog_model.dart';
import 'package:mevzuatim/models/blog_yorum.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcının oturum açıp açmadığını kontrol et
  bool _isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // Belirtilen blogId'ye ait toplam yorum sayısını döndür
  Future<int> getYorumSayisi(String blogId) async {
    try {
      // Firestore referansı
      final blogRef =
          _db.collection('blog_yorum').doc(blogId).collection('yorumlar');

      // Yorum sayısını al
      final querySnapshot = await blogRef.get();

      // Toplam yorum sayısını döndür
      return querySnapshot.size;
    } catch (e) {
      print('Hata: $e');
      return 0;
    }
  }

  // Blog koleksiyonundan manset field'ı "Düşünceleriniz" olan blogları al
  Future<List<BlogModel>> getBlogsByManset(String mansetValue) async {
    if (!_isUserLoggedIn()) {
      throw Exception('Yetkilendirme hatası: Kullanıcı giriş yapmamış.');
    }

    try {
      QuerySnapshot snapshot = await _db
          .collection('blog')
          .where('manset', isEqualTo: mansetValue)
          .orderBy('tarih', descending: true)
          .get();

      return snapshot.docs.map((doc) => BlogModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Bloglar alınamadı: $e');
    }
  }

  Future<BlogModel?> getBlogByID(String blogId) async {
    try {
      // Belirtilen blogId ile Firestore'dan blog verisini al
      DocumentSnapshot snapshot =
          await _db.collection('blog').doc(blogId).get();

      if (snapshot.exists) {
        // Firestore verisini BlogModel'e dönüştür
        return BlogModel.fromFirestore(snapshot);
      } else {
        // Blog bulunamazsa null döndür
        return null;
      }
    } catch (e) {
      throw Exception('Blog verisi alınırken hata oluştu: $e');
    }
  }

  // Kullanıcı adını getir
  Future<String?> getUserNameFromEmail(String email) async {
    return await _getUserField(email, 'kullanici adi');
  }

  // Kullanıcının yetkisini getir
  Future<String?> getUserRoleFromEmail(String email) async {
    return await _getUserField(email, 'yetki');
  }

  Future<Map<String, dynamic>?> getLastBlogByAuthId(String authId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Kullanıcının mail adresini bul
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(authId).get();

      if (!userDoc.exists) {
        print("Kullanıcı bulunamadı.");
        return null;
      }

      String userEmail = userDoc['mail'];

      // En son yazılan blogu tarihe göre sırala ve getir
      QuerySnapshot blogQuery = await firestore
          .collection('blogs')
          .where('yazar', isEqualTo: userEmail)
          .orderBy('tarih', descending: true)
          .limit(1)
          .get();

      if (blogQuery.docs.isEmpty) {
        print("Bu kullanıcıya ait blog bulunamadı.");
        return null;
      }

      return blogQuery.docs.first.data() as Map<String, dynamic>;
    } catch (e) {
      print("Hata oluştu: $e");
      return null;
    }
  }

  // Kullanıcı bilgilerini getiren ortak fonksiyon
  Future<String?> _getUserField(String email, String field) async {
    if (!_isUserLoggedIn()) {
      throw Exception('Yetkilendirme hatası: Kullanıcı giriş yapmamış.');
    }

    try {
      QuerySnapshot userSnapshot = await _db
          .collection('kullanıcılar')
          .where('mail', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print("User not found");
        return null;
      }

      return userSnapshot.docs.first[field];
    } catch (e) {
      print("Firestore error: $e");
      return null;
    }
  }

// Belirtilen e-postaya sahip kullanıcının Firestore'daki döküman ID'sini getir
  Future<String?> getUserIdFromEmail(String email) async {
    if (!_isUserLoggedIn()) {
      throw Exception('Yetkilendirme hatası: Kullanıcı giriş yapmamış.');
    }

    try {
      QuerySnapshot userSnapshot = await _db
          .collection('kullanıcılar')
          .where('mail', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print("Kullanıcı bulunamadı.");
        return null;
      }
      debugPrint("Denemee:${userSnapshot.docs.first.id}");
      return userSnapshot.docs.first.id; // Döküman ID'sini döndür
    } catch (e) {
      print("Firestore hatası: $e");
      return null;
    }
  }

  Future<BlogModel?> getBlogByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('blog')
          .where('mail', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return BlogModel.fromFirestore(snapshot.docs.first);
      } else {
        return null; // Blog bulunamazsa null döndür
      }
    } catch (e) {
      throw Exception('Blog verisi alınırken hata oluştu: $e');
    }
  }

  Future<String?> getUserEmailFromId(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _db.collection('kullanıcılar').doc(userId).get();

      if (!userSnapshot.exists) {
        print("Kullanıcı bulunamadı.");
        return null;
      }

      return userSnapshot['mail']; // Kullanıcının e-posta adresini döndür
    } catch (e) {
      print("Firestore hatası: $e");
      return null;
    }
  }

  Future<List<BlogYorum>> getYorumlar(String blogId) async {
    try {
      // Firestore referansı
      final blogRef = FirebaseFirestore.instance
          .collection('blog_yorum')
          .doc(blogId)
          .collection('yorumlar');

      // Yorumları çek
      final querySnapshot =
          await blogRef.orderBy('tarih', descending: true).get();

      // Yorumları BlogYorum modeline dönüştür
      List<BlogYorum> yorumlar = querySnapshot.docs.map((doc) {
        return BlogYorum.fromFirestore(doc);
      }).toList();

      return yorumlar;
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  // Yorum eklemek için fonksiyon
  Future<void> addComment(String blogId, String commentText) async {
    if (!_isUserLoggedIn()) {
      throw Exception('Yorum yapabilmek için giriş yapmanız gerekmektedir.');
    }

    try {
      // Kullanıcı bilgilerini al
      User? currentUser = _auth.currentUser;
      String userEmail = currentUser?.email ?? '';

      // Yorum verisi oluşturuluyor
      BlogYorum newComment = BlogYorum(
        yorum: commentText,
        kullaniciAdi: userEmail,
        tarih: Timestamp.now(),
      );

      // Yorum Firestore'a ekleniyor
      await _db
          .collection('blog_yorum')
          .doc(blogId)
          .collection('yorumlar')
          .add(newComment.toMap());

      print("Yorum başarıyla eklendi.");
    } catch (e) {
      print("Yorum eklenirken hata oluştu: $e");
      throw Exception("Yorum eklenirken bir hata oluştu.");
    }
  }

  Future<List<Map<String, dynamic>>> getBlogsByAuthor(
      String authorEmail) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('blog')
          .where('yazar', isEqualTo: authorEmail)
          .where('manset', isEqualTo: 'Düşünceleriniz')
          .get();

      // Blog sayısını ve içeriklerini döndürelim
      final blogCount = querySnapshot.docs.length;
      final blogContents = querySnapshot.docs.map((doc) {
        return {
          'icerik': doc['icerik'],
        };
      }).toList();

      print("Toplam okunmuş blog sayısı: $blogCount");

      return blogContents;
    } catch (e) {
      print('Hata oluştu: $e');
      return [];
    }
  }
}
