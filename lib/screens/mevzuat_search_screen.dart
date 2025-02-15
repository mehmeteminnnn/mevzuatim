import 'package:flutter/material.dart';

class MevzuatScreen extends StatelessWidget {
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: "Başlığa Göre Ara",
                    items: [
                      "Başlığa Göre Ara",
                      "İçeriğe Göre Ara",
                      "Her İkisine Göre Ara",
                      "Metnin Tamamına Göre Ara"
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Daha kompakt hale getirmek için küçültüldü
            TextField(
              style: TextStyle(fontSize: 14), // Font boyutu küçüldü
              decoration: InputDecoration(
                hintText: "Mevzuat Araması Yap",
                prefixIcon:
                    Icon(Icons.search, size: 20), // İkon boyutu küçültüldü
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Kenar yuvarlaklığı azaltıldı
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12), // İç boşluklar azaltıldı
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _showKlasorSecenekleri(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12), // Buton padding küçüldü
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder,
                      color: Colors.white, size: 18), // İkon boyutu küçültüldü
                  SizedBox(width: 6),
                  Text("Klasör Seçenekleri",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14)), // Font küçültüldü
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKlasorSecenekleri(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Klasör Seçenekleri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              CheckboxListTile(
                value: true,
                onChanged: (value) {},
                title: Text("Seçili klasör içinde ara"),
              ),
              Text(
                "Dosya seçebilmek için dosyanın üzerine geldikten sonra sağ tıklayıp “seç” butonuna basınız!",
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 10),
              Text("Dosya İsimleri"),
              Text("Mevzuatım", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: "Seçilen Klasör",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Devam"),
              ),
            ],
          ),
        );
      },
    );
  }
}
