String extractFilePath(String fullPath) {
    // 'Mevzuatim' kelimesinin bulunduğu index'i buluyoruz
    final startIndex = fullPath.indexOf('Mevzuatim\\');

    // Eğer 'Mevzuatim' bulunursa, sonrasını döndür
    if (startIndex != -1) {
      // 'Mevzuatim\' kısmının hemen sonrasını almak için startIndex + 'Mevzuatim'.length' kadar ilerliyoruz
      return fullPath.substring(startIndex + 'Mevzuatim\\'.length);
    } else {
      // Eğer 'Mevzuatim' bulunmazsa, boş bir değer döndürüyoruz
      return '';
    }
  }

  String formatFileName(String path) {
    // Hem \ hem / karakterine göre bölme işlemi
    String fileName = path.split(RegExp(r'[\\/]+')).last;
    if (fileName.endsWith('.docx')) {
      fileName = fileName.substring(0, fileName.length - 5);
    }
    return fileName;
  }