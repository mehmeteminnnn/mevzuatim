import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mevzuatim/models/satir_model.dart';

class GTIPModel {
  final String aciklama;
  final String baslik;
  final String baslikAnlami;
  final String link;
  final DateTime yayimTarih;
  final DateTime yururlukBaslangic;
  final DateTime? yururlukSon;
  final List<SatirModel> satirlar;

  GTIPModel({
    required this.aciklama,
    required this.baslik,
    required this.baslikAnlami,
    required this.link,
    required this.yayimTarih,
    required this.yururlukBaslangic,
    this.yururlukSon,
    required this.satirlar,
  });

  factory GTIPModel.fromJson(Map<String, dynamic> json) {
    return GTIPModel(
      aciklama: json['aciklama'] as String,
      baslik: json['baslik'] as String,
      baslikAnlami: json['baslik_anlami'] as String,
      link: json['link'] as String,
      yayimTarih: (json['yayim_tarih'] as Timestamp).toDate(),
      yururlukBaslangic: (json['yururluk_baslangic'] as Timestamp).toDate(),
      yururlukSon: json['yururluk_son'] != null
          ? (json['yururluk_son'] as Timestamp).toDate()
          : null,
      satirlar: (json['satirlar'] as List<dynamic>)
          .map((item) => SatirModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aciklama': aciklama,
      'baslik': baslik,
      'baslik_anlami': baslikAnlami,
      'link': link,
      'yayim_tarih': Timestamp.fromDate(yayimTarih),
      'yururluk_baslangic': Timestamp.fromDate(yururlukBaslangic),
      'yururluk_son': yururlukSon != null ? Timestamp.fromDate(yururlukSon!) : null,
      'satirlar': satirlar.map((item) => item.toJson()).toList(),
    };
  }
}
