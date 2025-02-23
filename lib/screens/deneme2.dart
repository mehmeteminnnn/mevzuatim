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

  final String docxUrl =
      "https://firebasestorage.googleapis.com/v0/b/denizproje-a9b67.appspot.com/o/Yeni%20klas%C3%B6r%2FAvrupa%20Birli%C4%9Fi%20Men%C5%9Feli%20Baz%C4%B1%20Tar%C4%B1m%20%C3%9Cr%C3%BCnleri%20%C4%B0thalat%C4%B1nda%20Tarife%20Kontenjan%C4%B1%20Uygulanmas%C4%B1na%20%C4%B0li%C5%9Fkin%20Tebli%C4%9Fde%20De%C4%9Fi%C5%9Fiklik%20Yap%C4%B1lmas%C4%B1na%20Dair%20Tebli%C4%9F_2020.12.31.docx?alt=media&token=b46a1951-0239-46d5-a053-fd0afd760e22";

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
