import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymClasses.dart';

class GymClassesClient {
  static final String url = '10.0.2.2:8000'; 
  static final String gymClassEndpoint = '/api/gymClass';

  static Future<List<GymClasses>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, gymClassEndpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => GymClasses.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<GymClasses> find(int id) async {
    try {
      var response = await get(Uri.http(url, '$gymClassEndpoint/$id')); 

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return GymClasses.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> updateKapasitas(int id, int kapasitasBaru) async {
    final response = await patch(
      Uri.http(url, '$gymClassEndpoint/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'kapasitas': kapasitasBaru,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update kapasitas');
    }
  }
}