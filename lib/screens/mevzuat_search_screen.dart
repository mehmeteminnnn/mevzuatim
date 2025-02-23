import 'package:flutter/material.dart';
import 'package:mevzuatim/services/algolia_service.dart';
import 'package:mevzuatim/screens/word_ekrani.dart'; // WordEkrani sayfasını import ettim
import 'package:mevzuatim/services/storage_service.dart';
import 'package:mevzuatim/utils/file_utils.dart';

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

  void _onSearchChanged() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
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
      results = [...titleResults, ...contentResults];
    }

    setState(() {
      _searchResults = results;
      _isLoading = false;
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
                  _onSearchChanged();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8),
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(
                                          url: StorageService().pathToUrl(
                                              extractFilePath(
                                                  item["baslik  "])),
                                          title:
                                              formatFileName(item["baslik  "]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
