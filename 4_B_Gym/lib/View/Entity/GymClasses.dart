import 'dart:convert';

import 'package:flutter/material.dart';

class GymClasses {
  int id;
  String nama_kelas;
  String jenis_kelas;
  String deskripsi;
  String hari;
  TimeOfDay jam;
  int durasi;
  int kapasitas;
  String instruktur;
  double harga;
  String image;

  GymClasses({
    required this.id,
    required this.nama_kelas,
    required this.jenis_kelas,
    required this.deskripsi,
    required this.hari,
    required this.jam,
    required this.durasi,
    required this.kapasitas,
    required this.instruktur,
    required this.harga,
    required this.image,
  });

  factory GymClasses.fromRawJson(String str) => GymClasses.fromJson(json.decode(str));
  
  factory GymClasses.fromJson(Map<String, dynamic> json) => GymClasses(
    id: json["id"],
    nama_kelas: json["nama_kelas"] ?? '',
    jenis_kelas: json["jenis_kelas"] ?? '',
    deskripsi: json["deskripsi"] ?? '',
    hari: json["hari"] ?? '',
    jam: _parseTime(json["jam"]),
    durasi: json["durasi"] ?? 0,
    kapasitas: json["kapasitas"] ?? 0,
    instruktur: json["instruktur"] ?? '',
    harga: (json["harga"] is String)
        ? double.tryParse(json["harga"]) ?? 0.0
        : json["harga"].toDouble(),
    image: json["image"] ?? '',
  );

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String toRawJson() => json.encode(toJson());
  
  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_kelas": nama_kelas,
    "jenis_kelas": jenis_kelas,
    "deskripsi": deskripsi,
    "hari": hari,
    "jam": "${jam.hour}:${jam.minute}",
    "durasi": durasi,
    "kapasitas": kapasitas,
    "instruktur": instruktur,
    "harga": harga,
    "image": image,
  };
}