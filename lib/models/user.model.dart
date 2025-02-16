class UserModel {
  final String kullaniciAdi;
  final String mail;
  final String parola;
  final String yetki;

  UserModel({
    required this.kullaniciAdi,
    required this.mail,
    required this.parola,
    required this.yetki,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      kullaniciAdi: json['kullaniciAdi'] as String,
      mail: json['mail'] as String,
      parola: json['parola'] as String,
      yetki: json['yetki'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kullaniciAdi': kullaniciAdi,
      'mail': mail,
      'parola': parola,
      'yetki': yetki,
    };
  }
}
