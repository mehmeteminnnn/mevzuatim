import 'package:algolia/algolia.dart';

class AlgoliaService {
  static final Algolia _algolia = Algolia.init(
    applicationId: 'BO2SLL34UL', // Algolia App ID
    apiKey: '550ba7996ccda8971e1b12be1c7499b4', // Algolia API Key
  );

  final String _indexName = 'test_index'; // Algolia index adı

  // Başlığa (baslik) göre arama yap
  Future<List<Map<String, dynamic>>> searchByTitle(String query) async {
    return _search(query);
  }

  // İçeriğe (icerik) göre arama yap
  Future<List<Map<String, dynamic>>> searchByContent(String query) async {
    return _search(query);
  }

  // Arama işlemi için ortak fonksiyon
  Future<List<Map<String, dynamic>>> _search(String query) async {
    try {
      final index = _algolia.instance.index(_indexName);

      final results = await index
          .query(query)
          .setHitsPerPage(25) // En fazla 25 sonuç getir
          .getObjects();

      // Bağlantı başarılıysa bu mesajı yazdır
      print("Algolia API'ye başarıyla bağlandı.");
      print("Sonuçlar: ${results.hits.map((e) => e.data)}");

      return results.hits.map((hit) => hit.data).toList();
    } catch (e, stacktrace) {
      print("Hata oluştu: $e");
      print("Stacktrace: $stacktrace");

      return [];
    }
  }
}
