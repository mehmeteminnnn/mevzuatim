import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mevzuatim/screens/main_screen.dart';
import 'package:mevzuatim/services/auth_service.dart';
import 'package:mevzuatim/screens/forgot_password_screen.dart'; // Şifre sıfırlama ekranı

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // SharedPreferences'tan kayıtlı e-posta ve şifreyi yükle
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('saved_email') ?? "";
      _passwordController.text = prefs.getString('saved_password') ?? "";
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  void _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-posta ve şifre alanlarını doldurun!')),
      );
      return;
    }

    bool success = await AuthService().loginUser(email, password, context);
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_email', email);
        await prefs.setString('saved_password', password);
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('saved_email');
        await prefs.remove('saved_password');
        await prefs.setBool('remember_me', false);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
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
            const SizedBox(height: 10),

            // "Beni Hatırla" ve "Şifremi Unuttum" seçenekleri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.blueAccent,
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text("Beni Hatırla"),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Giriş butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loginUser,
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
