import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id; // Blog doküman ID'si
  final String baslik;
  final String icerik;
  final String manset;
  final String ozet;
  final DateTime tarih;
  final String yazar;

  BlogModel({
    required this.id, // ID'yi constructor'a dahil et
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
      id: doc.id, // ID'yi alıyoruz
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
      'tarih': tarih.toIso8601String(),
      'yazar': yazar,
    };
  }

  // JSON'dan BlogModel'e dönüştürme
  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] as String, // ID'yi JSON'dan alıyoruz
      baslik: json['baslik'] as String,
      icerik: json['icerik'] as String,
      manset: json['manset'] as String,
      ozet: json['ozet'] as String,
      tarih: (json['tarih'] is Timestamp)
          ? (json['tarih'] as Timestamp).toDate()
          : DateTime.parse(json['tarih']),
      yazar: json['yazar'] as String,
    );
  }
}
