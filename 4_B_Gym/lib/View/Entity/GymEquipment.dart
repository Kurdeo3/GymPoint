import 'dart:convert';

import 'package:flutter/material.dart';

class GymEquipment {
  int id;
  String nama_alat;
  int jumlah;
  String deskripsi;
  String jenis_alat;
  double harga;
  String image;

  GymEquipment({
    required this.id,
    required this.nama_alat,
    required this.jumlah,
    required this.deskripsi,
    required this.jenis_alat,
    required this.harga,
    required this.image,
  });


  factory GymEquipment.fromRawJson(String str) => GymEquipment.fromJson(json.decode(str));
  
  factory GymEquipment.fromJson(Map<String, dynamic> json) => GymEquipment(
    id: json["id"],
    nama_alat: json["nama_alat"] ?? '',
    jumlah: json["jumlah"] ?? 0,
    deskripsi: json["deskripsi"] ?? '',
    jenis_alat: json["jenis_alat"] ?? '',
    harga: (json["harga"] is String)
        ? double.tryParse(json["harga"]) ?? 0.0
        : json["harga"].toDouble(),
    image: json["image"] ?? '',
  );

  String toRawJson() => json.encode(toJson());
  
  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_alat": nama_alat,
    "jumlah": jumlah,
    "deskripsi": deskripsi,
    "jenis_alat": jenis_alat,
    "harga": harga,
    "image": image,
  };
}