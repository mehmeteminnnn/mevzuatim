import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mevzuatim/models/job_experience_model.dart';


class UserProfileService {
  final String baseUrl = 'https://mevzuatim.com/profil-duzenle';

  Future<UserProfile?> fetchUserProfile(String uid) async {
    final url = Uri.parse('$baseUrl/$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserProfile.fromJson(data);
    } else {
      print('Kullanıcı verisi alınamadı: ${response.statusCode}');
      return null;
    }
  }
}
