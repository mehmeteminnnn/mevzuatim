import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcı girişi
  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String message = 'Bir hata oluştu. Lütfen tekrar deneyin.';
      if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunamadı!';
      } else if (e.code == 'wrong-password') {
        message = 'Yanlış şifre!';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return false;
    }
  }

  // Şifre sıfırlama e-postası gönderme
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("Şifre sıfırlama hatası: ${e.message}");
      return false;
    }
  }

  // Çıkış yapma
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // Kullanıcı bilgilerini al
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
