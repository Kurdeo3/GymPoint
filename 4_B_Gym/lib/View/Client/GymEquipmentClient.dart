import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymEquipment.dart';

class GymEquipmentClient {
  static final String url = '10.0.2.2:8000'; 
  static final String gymEquipmentEndpoint = '/api/gymEquipment';

  static Future<List<GymEquipment>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, gymEquipmentEndpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => GymEquipment.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<GymEquipment> find(int id) async {
    try {
      var response = await get(Uri.http(url, '$gymEquipmentEndpoint/$id')); 

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return GymEquipment.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> updateJumlah(int id, int jumlahBaru) async {
    final response = await patch(
      Uri.http(url, '$gymEquipmentEndpoint/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'jumlah': jumlahBaru,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update jumlah');
    }
  }
}