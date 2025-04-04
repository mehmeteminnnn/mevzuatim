import 'package:flutter/material.dart';
import 'package:mevzuatim/services/api_service.dart';

class GtipScreen extends StatefulWidget {
  @override
  State<GtipScreen> createState() => _GtipScreenState();
}

class _GtipScreenState extends State<GtipScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  String _result = 'Arama yapabilirsiniz'; // Başlangıç mesajı
  void _checkApi() async {
    await _apiService.testPostApi();
  }

  void _search() async {
    String query = _controller.text.trim(); // Boşlukları temizle
    if (query.isNotEmpty) {
      setState(() {
        _result = "Aranıyor..."; // Kullanıcıya bilgi ver
      });

      var response = await _apiService.searchTable(query);

      setState(() {
        _result = response != null ? response.toString() : 'Sonuç bulunamadı';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MEVZUATIM",
          style: TextStyle(
            color: Color(0xFF64B6AC), // Mavi renk
            fontSize: 20, // Daha küçük font
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40, // AppBar yüksekliği azaltıldı
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller, // Controller eklendi
              decoration: InputDecoration(
                hintText: "GTIP Araması Yap",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10), // Buton ile arasına boşluk eklendi
            ElevatedButton(
              onPressed: _search,
              child: Text("Ara"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _checkApi,
              child: Text("API Durumunu Kontrol Et"),
            ),

            Expanded(
              child: Container(
                width: double.infinity, // Genişliği tam ekran yap
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result, // API’den gelen sonuç burada gösterilecek
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
