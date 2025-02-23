import 'dart:convert'; // UTF-8 desteği için eklendi
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class TestWebViewPage extends StatefulWidget {
  @override
  _TestWebViewPageState createState() => _TestWebViewPageState();
}

class _TestWebViewPageState extends State<TestWebViewPage> {
  late WebViewController _controller;
  String? htmlContent;
  final String url =
      "https://firebasestorage.googleapis.com/v0/b/denizproje-a9b67.appspot.com/o/Dosyalar%2FDahilde%20%C4%B0%C5%9Fleme%20Rejimi%2FDahilde%20i%C5%9Fleme%20D1%20D2%20D3%20D4%20D5%20kodlar%C4%B1.docx?alt=media&token=ac7c1db9-1e47-45cb-9cbd-e855cb673447";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    fetchHtml();
  }

  Future<void> fetchHtml() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          htmlContent = utf8.decode(response.bodyBytes); // UTF-8 olarak çözüldü
          _loadHtmlContent(); // HTML içeriğini yükle
        });
      } else {
        setState(() {
          htmlContent = "<h2>Hata: ${response.statusCode}</h2>";
          _loadHtmlContent();
        });
      }
    } catch (e) {
      setState(() {
        htmlContent = "<h2>Bağlantı hatası: $e</h2>";
        _loadHtmlContent();
      });
    }
  }

  void _loadHtmlContent() {
    if (htmlContent != null) {
      final htmlPage = """
        <html>
          <head>
            <meta charset="UTF-8">
            <style>
              body { font-family: Arial, sans-serif; padding: 10px; }
            </style>
          </head>
          <body>
            
            <div>$htmlContent</div>
          </body>
        </html>
      """;
      _controller.loadHtmlString(htmlPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test WebView")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
