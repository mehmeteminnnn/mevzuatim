import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Firebase Storage URL'yi döndüren işlev
  String pathToUrl(String filePath) {
    final bucketName = 'denizproje-a9b67.appspot.com';

    // Dosya yolunu URL'ye encode et
    String encodedFilePath = Uri.encodeComponent(filePath);

    // %5C'i %2F ile değiştir
    encodedFilePath = encodedFilePath.replaceAll('%5C', '%2F');

    // URL'yi oluştur
    final url =
        'https://firebasestorage.googleapis.com/v0/b/$bucketName/o/$encodedFilePath?alt=media';

    debugPrint(url); // URL'yi konsola yazdır
    return url;
  }

  Future<String?> getUserPhotoByName(String fileName) async {
  try {
    // Kullanıcılar klasörüne referans al
    final Reference usersFolderRef = _storage.ref().child('kullanicilar');

    // Klasördeki dosyaları listele
    final ListResult result = await usersFolderRef.listAll();

    // Dosyalar arasında belirtilen fileName içeren ilk dosyayı ara
    for (final item in result.items) {
      if (item.name.contains(fileName)) {
        // Dosyanın URL'sini al
        final String downloadUrl = await item.getDownloadURL();
        debugPrint('Dosyanın URL\'si: $downloadUrl');
        return downloadUrl;
      }
    }

    // Eğer dosya bulunamazsa null döndür
    debugPrint('Belirtilen dosya bulunamadı.');
    return null;
  } catch (e) {
    debugPrint('Hata oluştu: $e');
    return null;
  }
}

}
