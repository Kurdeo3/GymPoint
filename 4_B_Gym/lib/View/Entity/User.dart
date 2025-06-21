import 'dart:convert';

class User {
  int? id;
  String nama;
  String username;
  String password;
  String email;
  int umur;
  String jenisKelamin;
  String noTelp;
  String? profilePicture;

  User({
    this.id,
    required this.nama,
    required this.username,
    required this.password,
    required this.email,
    required this.umur,
    required this.jenisKelamin,
    required this.noTelp,
    this.profilePicture
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    nama: json["nama"] ?? '', 
    username: json["username"] ?? '',
    email: json["email"] ?? '',
    password: json["password"] ?? '', 
    umur: json["umur"] ?? 0, 
    jenisKelamin: json["jenis_kelamin"] ?? '',
    noTelp: json["no_telp"] ?? '',
    profilePicture: json["profile_picture"] ?? '', 
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "username": username,
    "email": email,
    "password": password,
    "umur": umur,
    "jenis_kelamin": jenisKelamin,
    "no_telp": noTelp,
    "profile_picture":profilePicture,
  };


}