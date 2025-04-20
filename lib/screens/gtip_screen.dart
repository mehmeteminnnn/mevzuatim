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
  bool _searchSuccessful = false;

  Future<void> _search() async {
    if (_controller.text.isNotEmpty) {
      try {
        List<GtipModel> result =
            await _apiService.fetchGtipData(_controller.text);
        setState(() {
          _gtipList = result;
          _searchSuccessful = result.isNotEmpty;
        });

        if (_searchSuccessful) {
          _showSearchSuccessDialog();
        }
      } catch (e) {
        setState(() {
          _gtipList = [];
          _searchSuccessful = false;
        });
        print("Hata: $e");
      }
    } else {
      setState(() {
        _gtipList = [];
        _searchSuccessful = false;
      });
    }
  }

  void _showSearchSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Arama Başarılı'),
          content: Text('2. alt tablo için de arama yapabilirsiniz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "GTIP Araması Yap",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50),
                    backgroundColor: Color(0xFF64B6AC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: _gtipList.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 10,
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: gtip.altTablo.map((row) {
                                        if (row.length > 2 &&
                                            row[2].isNotEmpty) {
                                          String imageUrl =
                                              'https://mevzuatim.com/${row[2]}';
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            child: Image.network(
                                              imageUrl,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const SizedBox
                                                    .shrink(); // Hata olursa görünmez olur
                                              },
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      }).toList(),
                                    ),
                                  ),
                                ),
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
