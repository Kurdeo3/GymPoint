import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_application_tugasbesar/view/Entity/Booking.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';
import 'package:flutter_application_tugasbesar/view/Client/HistoryClient.dart';

class Bookingclient {
  static final String url = '10.0.2.2:8000'; 
  static final String bookingEndpoint = '/api/bookings';

  static Future<List<Booking>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, bookingEndpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Booking.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Booking> find(int id) async {
    try {
      var response = await get(Uri.http(url, '$bookingEndpoint/$id')); 

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Booking.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> create(Booking booking) async {
    try {
    final response = await post(
      Uri.http(url, '$bookingEndpoint/create'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${UserClient.token}',
        },
      body: booking.toRawJson(),
    );

      if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final bookingId = responseBody['data']['id'];
      
      await _createHistory(bookingId);
        print('Booking berhasil dibuat');
      } else {
        final errorMessage = json.decode(response.body)['message'] ?? response.reasonPhrase;
          throw Exception('Error saat membuat booking: $errorMessage');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat membuat booking: $e');
    }
  }

  static Future<void> _createHistory(int bookingId) async {
  try {
    final response = await post(
      Uri.http(url, '/api/history/create'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${UserClient.token}',
      },
      body: json.encode({
        'ID_Booking': bookingId
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal membuat history');
    }
  } catch (e) {
    print('Error membuat history: $e');
  }
}


}