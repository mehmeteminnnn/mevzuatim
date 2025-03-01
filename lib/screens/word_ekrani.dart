import 'dart:convert'; // UTF-8 desteği için eklendi
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  String? htmlContent;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
    

    fetchHtml();
  }

  Future<void> fetchHtml() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
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
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes">
          <style>
            body { 
              font-family: Arial, sans-serif; 
              font-size: 15px; /* Yazı boyutunu büyüttük */
              padding: 10px; 
            }
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
      appBar: AppBar(
        title: Text(
          widget.title, // Sayfa başlığı parametre olarak alındı
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Başlığı ortala
        backgroundColor: Colors.white, // Arka plan rengi
        elevation: 4, // Hafif gölge efekti
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
