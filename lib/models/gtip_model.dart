class GtipModel {
  final int id;
  final String gtipNo;
  final String tanim;
  final String olcu;
  final String vergi;
  final List<List<String>> altTablo;

  GtipModel({
    required this.id,
    required this.gtipNo,
    required this.tanim,
    required this.olcu,
    required this.vergi,
    required this.altTablo,
  });

  factory GtipModel.fromJson(Map<String, dynamic> json) {
    return GtipModel(
      id: json['id'],
      gtipNo: json['gtip_no'],
      tanim: json['tanim'],
      olcu: json['olcu'] ?? '-',
      vergi: json['vergi'] ?? '-',
      altTablo: List<List<String>>.from(
          json['alt_tablo']['list'].map((item) => List<String>.from(item))),
    );
  }
}
