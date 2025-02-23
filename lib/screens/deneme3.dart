import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWebViewPage extends StatefulWidget {
  @override
  _TestWebViewPageState createState() => _TestWebViewPageState();
}

class _TestWebViewPageState extends State<TestWebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadHtmlContent();
  }

  void _loadHtmlContent() {
    final htmlContent = """
      <html>
        <head><meta charset="UTF-8"></head>
        <body>
          <table>
            <tr>
              <td>
                <table>
                  <tr>
                    <td><p>31 Aralık 2020 PERŞEMBE</p></td>
                    <td><p><strong>Resmî Gazete</strong></p></td>
                    <td><p>Sayısı : 31351</p></td>
                  </tr>
                  <tr>
                    <td colspan="3"><p><strong>TEBLİĞ</strong></p></td>
                  </tr>
                  <tr>
                    <td colspan="3"><p><strong>&nbsp;</strong></p></td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
          <p>&nbsp;</p>
          <p>Ticaret Bakanlığından:</p>
          <p><strong>AVRUPA BİRLİĞİ MENŞELİ BAZI TARIM ÜRÜNLERİ İTHALATINDA</strong></p>
          <p><strong>TARİFE KONTENJANI UYGULANMASINA İLİŞKİN TEBLİĞDE</strong></p>
          <p><strong>DEĞİŞİKLİK YAPILMASINA DAİR TEBLİĞ</strong></p>
          <p><strong>&nbsp;</strong></p>
          <p><strong>MADDE 1 –</strong> 7/7/2018 tarihli ve 30471 mükerrer sayılı Resmî Gazete’de yayımlanan Avrupa Birliği Menşeli Bazı Tarım Ürünleri İthalatında Tarife Kontenjanı Uygulanmasıyla İlgili Tebliğin Ek-1’inde yer alan Avrupa Birliği Menşeli Bazı Tarım Ürünleri İthalatında Uygulanan Tarife Kontenjanları Listesinde bulunan AB040 kod numaralı tarife kontenjanı satırı aşağıdaki şekilde değiştirilmiş ve aynı Listenin sonuna aşağıdaki dipnot eklenmiştir.</p>
          <p>“</p>
          <table>
            <tr>
              <td rowspan="2"><p>AB040<sup>(3)</sup></p></td>
              <td><p>1207.70.00.00.00</p></td>
              <td><p>Kavun, Karpuz tohumu</p></td>
              <td rowspan="2"><p>01.01-31.12</p></td>
              <td rowspan="2"><p>&nbsp;</p></td>
              <td rowspan="2"><p>BSGTY</p></td>
              <td rowspan="2"><p>&nbsp;</p></td>
            </tr>
            <tr>
              <td><p>12.09</p><p>(1209.10.00.00.00 hariç)</p></td>
              <td><p>Ekim amacıyla kullanılan tohum, meyve ve sporlar</p></td>
            </tr>
          </table>
          <p>“(3) Tarife kontenjanı miktarı eşit dilimler halinde çeyrek dönemler itibarıyla tahsis edilir.”</p>
          <p><strong>MADDE 2 –</strong> Bu Tebliğ 1/1/2021 tarihinde yürürlüğe girer.</p>
          <p><strong>MADDE 3 –</strong> Bu Tebliğ hükümlerini Ticaret Bakanı yürütür.</p>
          <table>
            <tr>
              <td colspan="3"><p><strong>Tebliğin Yayımlandığı Resmî Gazete'nin</strong></p></td>
            </tr>
            <tr>
              <td colspan="2"><p><strong>Tarihi</strong></p></td>
              <td><p><strong>Sayı</strong></p></td>
            </tr>
            <tr>
              <td colspan="2"><p>7/7/2018</p></td>
              <td><p>30471</p></td>
            </tr>
            <tr>
              <td colspan="3"><p><strong>Tebliğde Değişiklik Yapan Tebliğlerin Yayınlandığı Resmî Gazete'nin</strong></p></td>
            </tr>
            <tr>
              <td colspan="2"><p><strong>Tarihi</strong></p></td>
              <td><p><strong>Sayı</strong></p></td>
            </tr>
            <tr>
              <td><p>1-</p></td>
              <td><p>19/10/2018</p></td>
              <td><p>30570</p></td>
            </tr>
            <tr>
              <td><p>2-</p></td>
              <td><p>17/11/2018</p></td>
              <td><p>30598</p></td>
            </tr>
          </table>
        </body>
      </html>
    """;

    _controller.loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test WebView")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
