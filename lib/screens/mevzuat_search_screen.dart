import 'package:flutter/material.dart';
import 'package:mevzuatim/services/algolia_service.dart';

class MevzuatScreen extends StatefulWidget {
  @override
  _MevzuatScreenState createState() => _MevzuatScreenState();
}

class _MevzuatScreenState extends State<MevzuatScreen> {
  final AlgoliaService _algoliaService = AlgoliaService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  String _searchType = "Başlığa Göre Ara"; // Varsayılan arama türü
  bool _isLoading = false; // Yükleniyor durumu



  String getStoragePath(String filePath) {
  // Windows için ters eğik çizgi (\) yerine düz eğik çizgi (/) kullan
  filePath = filePath.replaceAll(r'\', '/');

  // "Mevzuatim/" kelimesinin başlangıç indeksini bul
  int startIndex = filePath.indexOf("Mevzuatim/");
  if (startIndex == -1) {
    throw Exception("Dosya yolu geçersiz: 'Mevzuatim/' bulunamadı.");
  }

  // "Mevzuatim/" kısmından sonrasını al
  String storagePath = filePath.substring(startIndex + "Mevzuatim/".length);

  return storagePath;
}

  String formatFileName(String path) {
    // Son \ işaretinin olduğu yerden başlayarak al
    String fileName = path.split('\\').last;

    // .docx uzantısını kaldır
    if (fileName.endsWith('.docx')) {
      fileName = fileName.substring(0, fileName.length - 5);
    }

    return fileName;
  }

  void _onSearchChanged() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true; // Yükleniyor başlat
    });

    List<Map<String, dynamic>> results = [];

    if (_searchType == "Başlığa Göre Ara") {
      results = await _algoliaService.searchByTitle(_searchController.text);
    } else if (_searchType == "İçeriğe Göre Ara") {
      results = await _algoliaService.searchByContent(_searchController.text);
    } else if (_searchType == "Her İkisine Göre Ara") {
      final titleResults =
          await _algoliaService.searchByTitle(_searchController.text);
      final contentResults =
          await _algoliaService.searchByContent(_searchController.text);
      results = [...titleResults, ...contentResults]; // İki sonucu birleştir
    }

    setState(() {
      _searchResults = results;
      _isLoading = false; // Yükleniyor bitti
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "MEVZUATIM",
          style: TextStyle(
            color: Color(0xFF64B6AC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arama türü seçme dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonFormField<String>(
                value: _searchType,
                items: [
                  "Başlığa Göre Ara",
                  "İçeriğe Göre Ara",
                  "Her İkisine Göre Ara",
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _searchType = value!;
                  });
                  _onSearchChanged(); // Arama türü değiştiğinde arama yapılacak
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Arama kutusu
            TextField(
              controller: _searchController,
              onChanged: (text) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: "Mevzuat Araması Yap",
                prefixIcon: Icon(Icons.search, color: Color(0xFF64B6AC)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF64B6AC)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: 16),
            // Yükleniyor animasyonu veya Arama sonuçları
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _searchResults.isEmpty
                        ? Center(child: Text("Sonuç bulunamadı."))
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final item = _searchResults[index];
                              return Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  title: Text(
                                    formatFileName(item["baslik  "]) ??
                                        "Başlık bulunamadı",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item["icerik"] ?? "İçerik bulunamadı",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Color(0xFF64B6AC),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
            SizedBox(height: 8),
            // Klasör seçenekleri button at the bottom
            /* ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.folder, color: Colors.white),
              label: Text("Klasör Seçenekleri"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF64B6AC),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
