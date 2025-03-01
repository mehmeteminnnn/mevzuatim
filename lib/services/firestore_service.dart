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
      final blogRef = _db
          .collection('blog_yorum')
          .doc(blogId)
          .collection('yorumlar');

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
          .get();

      return snapshot.docs.map((doc) => BlogModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Bloglar alınamadı: $e');
    }
  }
  Future<BlogModel?> getBlogByID(String blogId) async {
  try {
    // Belirtilen blogId ile Firestore'dan blog verisini al
    DocumentSnapshot snapshot = await _db.collection('blog').doc(blogId).get();

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
}
