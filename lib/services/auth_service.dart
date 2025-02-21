import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı giriş fonksiyonu
  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    try {
      var querySnapshot = await _firestore
          .collection('kullanıcılar')
          .where('mail', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('E-posta adresi bulunamadı!')),
        );
        return false;
      }

      var userDoc = querySnapshot.docs.first;
      String storedPassword = userDoc['parola'];

      if (password == storedPassword) {
        return true; // Giriş başarılı
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifre yanlış!')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
      return false;
    }
  }
}
