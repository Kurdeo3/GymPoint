import 'dart:convert';

import 'package:flutter/material.dart';

class History {
  int? id;
  String jenis_layanan;
  String nama_personalTrainer;
  DateTime tanggal_booking;
  int ID_User;
  int ID_Booking;

  History({
    this.id,
    required this.jenis_layanan,
    required this.nama_personalTrainer,
    required this.tanggal_booking,
    required this.ID_User,
    required this.ID_Booking,
  });

  factory History.fromRawJson(String str) => History.fromJson(json.decode(str));
  
  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"],
    jenis_layanan: json["jenis_layanan"] ?? '',
    nama_personalTrainer: json["nama_personalTrainer"] ?? '',
    tanggal_booking: json["date"] is String 
                    ? DateTime.parse(json["date"])
                    : json["date"] is DateTime
                      ? json["date"]
                      : DateTime.now(),
    ID_User: json["ID_User"],
    ID_Booking: json["ID_Booking"],
  );

  String toRawJson() => json.encode(toJson());
  
  Map<String, dynamic> toJson() => {
    "id": id,
    "jenis_layanan": jenis_layanan,
    "nama_personalTrainer": nama_personalTrainer,
    "tanggal_booking": tanggal_booking.toIso8601String(),
    "ID_User": ID_User,
    "ID_Booking": ID_Booking,
  };
}