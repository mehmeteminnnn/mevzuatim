import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String baslik;
  final String icerik;
  final String manset;
  final String ozet;
  final DateTime tarih;
  final String yazar;

  BlogModel({
    required this.baslik,
    required this.icerik,
    required this.manset,
    required this.ozet,
    required this.tarih,
    required this.yazar,
  });

  // Firestore'dan gelen veriyi BlogModel'e dönüştür
  factory BlogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; 
    return BlogModel(
      baslik: data['baslik'] ?? '', 
      icerik: data['icerik'] ?? '', 
      manset: data['manset'] ?? '', 
      ozet: data['ozet'] ?? '', 
      tarih: (data['tarih'] as Timestamp).toDate(), 
      yazar: data['yazar'] ?? '', 
    );
  }

  // Modeli JSON formatına dönüştür
  Map<String, dynamic> toJson() {
    return {
      'baslik': baslik,
      'icerik': icerik,
      'manset': manset,
      'ozet': ozet,
      'tarih': tarih.toIso8601String(), // DateTime'ı ISO formatında string'e çevir
      'yazar': yazar,
    };
  }

  // JSON'dan BlogModel'e dönüştürme
  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      baslik: json['baslik'] as String,
      icerik: json['icerik'] as String,
      manset: json['manset'] as String,
      ozet: json['ozet'] as String,
      tarih: (json['tarih'] is Timestamp) ? (json['tarih'] as Timestamp).toDate() : DateTime.parse(json['tarih']), // Firestore'dan Timestamp geliyorsa DateTime'a çevir
      yazar: json['yazar'] as String,
    );
  }
}
