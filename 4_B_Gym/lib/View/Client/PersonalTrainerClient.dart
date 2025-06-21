import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_application_tugasbesar/view/Entity/PersonalTrainer.dart';

class PersonalTrainerClient {
  static final String url = '10.0.2.2:8000'; 
  static final String personalTrainerEndpoint = '/api/personalTrainer';

  static Future<List<PersonalTrainer>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, personalTrainerEndpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => PersonalTrainer.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<PersonalTrainer> find(int id) async {
    try {
      var response = await get(Uri.http(url, '$personalTrainerEndpoint/$id')); 

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return PersonalTrainer.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}