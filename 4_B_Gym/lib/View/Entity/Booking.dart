import 'dart:convert';

import 'package:flutter/material.dart';

class Booking {
  int? id;
  String jenis_layanan;
  DateTime date;
  double harga;
  int ID_User;
  int? ID_PersonalTrainer;
  int? ID_GymClass;
  int? ID_Equipment;

  Booking({
    this.id,
    required this.jenis_layanan,
    required this.date,
    required this.harga,
    required this.ID_User,
    this.ID_PersonalTrainer,
    this.ID_GymClass,
    this.ID_Equipment
  });


  factory Booking.fromRawJson(String str) => Booking.fromJson(json.decode(str));
  
  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    jenis_layanan: json["jenis_layanan"] ?? '',
    date: json["date"] is String 
        ? DateTime.parse(json["date"])
        : json["date"] is DateTime
          ? json["date"]
          : DateTime.now(),
    harga: (json["harga"] is String)
        ? double.tryParse(json["harga"]) ?? 0.0
        : json["harga"].toDouble(),
    ID_User: json["ID_User"],
    ID_PersonalTrainer: json["ID_PersonalTrainer"],
    ID_GymClass: json["ID_GymClass"],
    ID_Equipment: json["ID_Equipment"],
  );

  String toRawJson() => json.encode(toJson());
  
  Map<String, dynamic> toJson() => {
    "id": id,
    "jenis_layanan": jenis_layanan,
    "date": date.toIso8601String(),
    "harga": harga,
    "ID_User": ID_User,
    "ID_PersonalTrainer": ID_PersonalTrainer,
    "ID_GymClass": ID_GymClass,
    "ID_Equipment": ID_Equipment,
  };
}