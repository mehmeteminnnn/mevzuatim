import 'package:flutter/material.dart';

class StorageService {
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
}
