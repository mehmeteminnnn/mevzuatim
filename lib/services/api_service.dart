import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mevzuatim/models/gtip_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.mevzuatim.com/tablo-ara/';
  static const String _baseUrlalttablo = 'https://www.mevzuatim.com/alt-tablo';

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

  Future<List<GtipModel>> fetchGtipData(String search) async {
    testPostApi();
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: jsonEncode({'search': search}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        return data.map((json) => GtipModel.fromJson(json)).toList();
      } else {
        throw Exception("API Hatası: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Bağlantı hatası: $e");
    }
  }

  Future<void> fetchAltTablo() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrlalttablo),
        body: jsonEncode({
          "alt_tablo": [""],
          "gtip": "7004"
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print("Alt Tablo JSON Verisi:");
        print(jsonEncode(jsonData)); // Tüm JSON veriyi yazdırır

        // Eğer sadece 'list' kısmı lazımsa:
        if (jsonData.containsKey('list')) {
          print("Alt Tablo List:");
          print(jsonEncode(jsonData['list']));
        }
      } else {
        print(
            "Alt tablo verisi alınamadı. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Alt tablo API hatası: $e");
    }
  }
}
