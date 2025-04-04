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
              onChanged: (_) => _search(), // 👈 Yazdıkça tetiklenir
              decoration: InputDecoration(
                hintText: "GTIP Araması Yap",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            // ElevatedButton kaldırıldı ✅
            Expanded(
              child: _gtipList.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 15,
                        columns: const [
                          DataColumn(label: Text("G.T.İ.P")),
                          DataColumn(label: Text("Tanım")),
                          DataColumn(label: Text("Ölçü Birimi")),
                          DataColumn(label: Text("Vergi")),
                        ],
                        rows: _gtipList.map((gtip) {
                          return DataRow(cells: [
                            DataCell(Text(gtip.gtipNo)),
                            DataCell(Text(gtip.tanim)),
                            DataCell(Text(gtip.olcu)),
                            DataCell(Text(gtip.vergi)),
                          ]);
                        }).toList(),
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
