import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mevzuatim/models/job_experience_model.dart';
import 'package:http_parser/http_parser.dart'; // Dosya tipi için gerekli
import 'package:mime/mime.dart';

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

  Future<bool> updateProfileImage(String uid, File imageFile) async {
    try {
      final url = Uri.parse('$baseUrl/$uid');

      final request = http.MultipartRequest('POST', url);

      // Form alanı ekle
      request.fields['form_type'] = 'profil_image';

      // Dosya tipi ayarla
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          'profil_image', // sunucu tarafında bu isimle alınmalı
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      // İsteği gönder
      final response = await request.send();

      // Response body’yi oku
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print(' Profil resmi güncellendi: $responseBody');
        return true;
      } else {
        print('Hata: Sunucu ${response.statusCode} döndü.');
        print('🔍 Detay: $responseBody');
        return false;
      }
    } catch (e) {
      print(' İstisna oluştu: $e');
      return false;
    }
  }

  /// ✅ Hakkımda güncelle
  Future<bool> updateAboutMe(String uid, String aboutMe) async {
    final url = Uri.parse('$baseUrl/$uid');
    final response = await http.post(
      url,
      body: {
        'form_type': 'about_me',
        'about_me': aboutMe,
      },
    );
    return response.statusCode == 200;
  }

  /// ✅ Uzmanlık alanlarını güncelle
  Future<bool> updateExpertise(String uid, List<String> expertiseList) async {
    final url = Uri.parse('$baseUrl/$uid');
    final response = await http.post(
      url,
      body: {
        'form_type': 'expertise',
        'expertise': expertiseList.join(', '),
      },
    );
    return response.statusCode == 200;
  }

  /// ✅ İş deneyimi ekle/güncelle
  Future<bool> updateJobExperience({
    required String uid,
    required String id, //jobId varsa
    required String jobTitle,
    required String companyName,
    required String employmentType,
    required String startDate,
    required String endDate,
    required String city,
    required String workMode,
  }) async {
    final url = Uri.parse('$baseUrl/$uid');
    final response = await http.post(
      url,
      body: {
        'form_type': 'job_experience',
        'job_id': id,
        'job_title': jobTitle,
        'company_name': companyName,
        'employment_type': employmentType,
        'start_date': startDate,
        'end_date': endDate,
        'city': city,
        'work_mode': workMode,
      },
    );
    return response.statusCode == 200;
  }
}
