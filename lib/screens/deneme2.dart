import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:docx_template/docx_template.dart';

class WordWebViewTest extends StatefulWidget {
  @override
  _WordWebViewTestState createState() => _WordWebViewTestState();
}

class _WordWebViewTestState extends State<WordWebViewTest> {
  late WebViewController _controller;
  String _htmlContent = "<p>Yükleniyor...</p>";

  final String docxUrl="";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadDocxFromUrl(docxUrl);
  }

  Future<void> _loadDocxFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp.docx');
        await tempFile.writeAsBytes(response.bodyBytes);

        final docx = await DocxTemplate.fromBytes(await tempFile.readAsBytes());
        final docxText = docx.toString(); // DOCX içeriğini al

        // UTF-8 karakter setini ekleyerek HTML içeriğini oluşturuyoruz
        setState(() {
          _htmlContent = """
            <html>
              <head><meta charset="UTF-8"></head>
              <body>${docxText.replaceAll("\n", "<br>")}</body>
            </html>
          """;
        });

        // WebView'e HTML içeriğini yüklüyoruz
        _controller.loadRequest(Uri.dataFromString(_htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
      } else {
        throw Exception("Dosya indirilemedi. HTTP ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _htmlContent = "<p>Hata: ${e.toString()}</p>";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebView Test")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
