class SatirModel {
  final int satirSayisi;
  final List<String> satirVeri;

  SatirModel({
    required this.satirSayisi,
    required this.satirVeri,
  });

  factory SatirModel.fromJson(Map<String, dynamic> json) {
    return SatirModel(
      satirSayisi: json['satir_sayisi'] as int,
      satirVeri: List<String>.from(json['satir_veri'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'satir_sayisi': satirSayisi,
      'satir_veri': satirVeri,
    };
  }
}
