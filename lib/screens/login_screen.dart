import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart'; // AuthService'i içe aktar
import 'package:mevzuatim/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final AuthService _authService = AuthService();

  void _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-posta ve şifre alanlarını doldurun!')),
      );
      return;
    }

    User? user = await _authService.signInWithEmail(email, password);
    if (user != null) {
      // Başarıyla giriş yaptı
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız, bilgilerinizi kontrol edin!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.webp', width: 100),
            const SizedBox(height: 40),

            // E-posta alanı
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Şifre alanı
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                labelText: 'Şifre',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),

            // Giriş butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loginUser, // Giriş işlemini başlatır
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
