import 'package:flutter/material.dart';
import 'package:mevzuatim/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen e-posta adresinizi girin")),
      );
      return;
    }

    bool success = await AuthService().sendPasswordResetEmail(email);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Şifre sıfırlama bağlantısı e-postanıza gönderildi!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre sıfırlama başarısız, tekrar deneyin!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Şifremi Unuttum",
          style: TextStyle(
            color: Color(0xFF64B6AC), // Mavi renk
            fontSize: 20, // Daha küçük font
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*Image.asset('assets/logo.webp', width: 100, height: 100), // Logo
            const SizedBox(height: 20),*/

            Text(
              "Şifre Sıfırlama",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Text(
              "Hesabınıza bağlı e-posta adresinizi girin. Şifre sıfırlama bağlantısı e-postanıza gönderilecektir.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            // E-posta giriş alanı
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-posta adresinizi girin",
                labelStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Şifre sıfırlama butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Şifre Sıfırla",
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
