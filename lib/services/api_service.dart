import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://www.mevzuatim.com/tablo-ara/';
  Future<void> testPostApi() async {
    try {
      final response = await http.post(
        Uri.parse('https://www.mevzuatim.com/tablo-ara/'),
        //headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'search': '0302'}),
      );
      print("API Yanıt Kodu: ${response.statusCode}\nYanıt: ${response.body}");
    } catch (e) {
      print("API hatası: $e");
    }
  }

  Future<bool> checkApiStatus() async {
    final Uri url = Uri.parse(_baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(" API çalışıyor!");
        return true;
      } else {
        print(" API çalışmıyor! Hata: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("⚠️ API'ye bağlanırken hata oluştu: $e");
      return false;
    }
  }

  Future<dynamic> searchTable(String query) async {
    final Uri url = Uri.parse(_baseUrl);

    final Map<String, dynamic> requestBody = {
      'search': query, // API'nin istediği "search" anahtar kelimesi
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Başarılı yanıt döndüğünde JSON'u parse et
        return jsonDecode(response.body);
      } else {
        // Hata durumunda log yazdır
        print('Hata: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Bağlantı hatası: $e');
      return null;
    }
  }
}
