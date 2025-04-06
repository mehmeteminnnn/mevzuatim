import 'package:flutter/material.dart';
import 'package:mevzuatim/services/api_service.dart';
import 'package:mevzuatim/models/gtip_model.dart';

class GtipScreen extends StatefulWidget {
  @override
  State<GtipScreen> createState() => _GtipScreenState();
}

class _GtipScreenState extends State<GtipScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  List<GtipModel> _gtipList = [];

  Future<void> _search() async {
    if (_controller.text.isNotEmpty) {
      try {
        List<GtipModel> result =
            await _apiService.fetchGtipData(_controller.text);
        setState(() {
          _gtipList = result;
        });
      } catch (e) {
        setState(() {
          _gtipList = [];
        });
        print("Hata: $e");
      }
    } else {
      setState(() {
        _gtipList = [];
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (_) => _search(), // Arama yapıldıkça güncelle
              decoration: InputDecoration(
                hintText: "GTIP Araması Yap",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: _apiService.fetchAltTablo, child: Text("Test")),
            SizedBox(height: 10),
            Expanded(
              child: _gtipList.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 10, // Daha az boşluk bırakıyoruz
                          columns: const [
                            DataColumn(
                              label: SizedBox(
                                width: 80,
                                child: Text("G.T.İ.P",
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 150,
                                child: Text("Tanım",
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text("Ölçü Birimi",
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 80,
                                child: Text("Vergi",
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 80,
                                child: Text("Alt Tablolar",
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                          rows: _gtipList.map((gtip) {
                            return DataRow(cells: [
                              DataCell(SizedBox(
                                  width: 80,
                                  child: Text(gtip.gtipNo,
                                      overflow: TextOverflow.ellipsis))),
                              DataCell(SizedBox(
                                  width: 150,
                                  child: Text(gtip.tanim,
                                      overflow: TextOverflow.ellipsis))),
                              DataCell(SizedBox(
                                  width: 100,
                                  child: Text(gtip.olcu,
                                      overflow: TextOverflow.ellipsis))),
                              DataCell(SizedBox(
                                  width: 80,
                                  child: Text(gtip.vergi,
                                      overflow: TextOverflow.ellipsis))),
                              DataCell(
                                SizedBox(
                                    width: 80,
                                    child: Text(
                                      gtip.altTablo
                                          .map((row) {
                                            // Her satırda 3. eleman var mı kontrol et
                                            if (row.length > 2) {
                                              return row[2];
                                            } else {
                                              return '';
                                            }
                                          })
                                          .where((value) => value
                                              .isNotEmpty) // Boş stringleri filtrele
                                          .join(
                                              ', '), // Kalanları , ile birleştir
                                    )),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    )
                  : Center(child: Text("Arama yapabilirsiniz")),
            ),
          ],
        ),
      ),
    );
  }
}
