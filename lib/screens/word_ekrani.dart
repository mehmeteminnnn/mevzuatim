import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:docx_template/docx_template.dart';

class WordEkrani extends StatefulWidget {
  final String docxUrl; // Firebase Storage veya internetten gelen docx URL'si

  WordEkrani({required this.docxUrl});

  @override
  _WordEkraniState createState() => _WordEkraniState();
}

class _WordEkraniState extends State<WordEkrani> {
  late final WebViewController _controller;
  String _htmlContent = "<p>Yükleniyor...</p>";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadDocxFromUrl(widget.docxUrl);
  }

  Future<void> _loadDocxFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp.docx');
        await tempFile.writeAsBytes(response.bodyBytes);

        final docx = await DocxTemplate.fromBytes(await tempFile.readAsBytes());

        //final docx = await DocxTemplate.fromFile(tempFile);
        final docxText = docx.toString(); // DOCX içeriğini al

        setState(() {
          _htmlContent = "<p>${docxText.replaceAll("\n", "<br>")}</p>";
        });

        _controller.loadHtmlString(_htmlContent);
      } else {
        throw Exception("Dosya yüklenemedi");
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
      appBar: AppBar(title: Text("Word İçeriği")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
