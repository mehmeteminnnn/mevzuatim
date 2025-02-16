import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcı giriş yapma fonksiyonu
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Giriş hatası: $e");
      return null;
    }
  }

  // Çıkış yapma fonksiyonu
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
