import 'dart:convert';

import 'package:flutter/material.dart';

class PersonalTrainer {
  int id;
  String nama;
  int umur;
  String jenis_kelamin;
  String spesialisasi;
  String no_telp;
  double harga;
  String image;

  PersonalTrainer({
    required this.id,
    required this.nama,
    required this.umur,
    required this.jenis_kelamin,
    required this.spesialisasi,
    required this.no_telp,
    required this.harga,
    required this.image,
  });


  factory PersonalTrainer.fromRawJson(String str) => PersonalTrainer.fromJson(json.decode(str));
  
  factory PersonalTrainer.fromJson(Map<String, dynamic> json) => PersonalTrainer(
    id: json["id"],
    nama: json["nama"] ?? '',
    umur: json["umur"] ?? 0,
    jenis_kelamin: json["jenis_kelamin"] ?? '',
    spesialisasi: json["spesialisasi"] ?? '',
    no_telp: json["no_telp"] ?? '',
    harga: (json["harga"] is String)
        ? double.tryParse(json["harga"]) ?? 0.0
        : json["harga"].toDouble(),
    image: json["image"] ?? '',
  );

  String toRawJson() => json.encode(toJson());
  
  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "umur": umur,
    "jenis_kelamin": jenis_kelamin,
    "spesialisasi": spesialisasi,
    "no_telp": no_telp,
    "harga": harga,
    "image": image,
  };
}