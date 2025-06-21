import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_application_tugasbesar/view/Entity/History.dart';
import 'package:flutter_application_tugasbesar/view/Entity/User.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';

class Historyclient {
  static final String url = '10.0.2.2:8000'; 
  static final String historyEndpoint = '/api/history';

  static Future<List<dynamic>> fetchAllHistories() async {
    try {
      final response = await get(
        Uri.http(url, '$historyEndpoint'),
        headers: {
          'Authorization': 'Bearer ${UserClient.token}',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['data'] ?? [];
      } else {
        throw Exception('Gagal memuat semua history');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> fetchHistoriesByServiceType(String jenisLayanan) async {
    try {
      final response = await get(
        Uri.http(url, '$historyEndpoint/$jenisLayanan'),
        headers: {
          'Authorization': 'Bearer ${UserClient.token}',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('Response Body: $responseBody');

        final List<dynamic> histories = responseBody['data'] ?? [];
        
        print('Jumlah Histories: ${histories.length}');

        return histories;
      } else {
        print('Error Response Body: ${response.body}');
        
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal memuat history $jenisLayanan');
      }
    } catch (e) {
      print('Error fetching histories: $e');
      throw Exception('Error: $e');
    }
  }
}