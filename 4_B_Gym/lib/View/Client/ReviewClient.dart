import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_tugasbesar/view/Entity/Review.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';

class ReviewClient {
  static const String url = '10.0.2.2:8000'; 
  static const String reviewEndpoint = '/api/reviews';

  static Future<List<Review>> fetchAll() async {
    try {
      final uri = Uri.http(url, reviewEndpoint);
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load reviews: ${response.statusCode} ${response.reasonPhrase}');
      }

      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      return Future.error('Error fetching reviews: $e');
    }
  }

  static Future<Review> find(int id) async {
    try {
      final uri = Uri.http(url, '$reviewEndpoint/$id');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load review: ${response.statusCode} ${response.reasonPhrase}');
      }

      return Review.fromRawJson(response.body);
    } catch (e) {
      return Future.error('Error fetching review: $e');
    }
  }

  static Future<Review> create(Review review) async {
    try {
      final response = await http.post(
      Uri.http(url, '/api/reviews'),
      headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${UserClient.token}',
        },
      body: review.toRawJson(),
    );

      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create review: ${response.statusCode} ${response.reasonPhrase}');
      }

      return Review.fromRawJson(response.body);
    } catch (e) {
      return Future.error('Error creating review: $e');
    }
  }

  static Future<Review> update(Review review, int id) async {
    try {
      final uri = Uri.http(url, '$reviewEndpoint/$id');
      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: review.toRawJson(),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update review: ${response.statusCode} ${response.reasonPhrase}');
      }

      return Review.fromRawJson(response.body);
    } catch (e) {
      return Future.error('Error updating review: $e');
    }
  }

  static Future<void> destroy(int id) async {
    try {
      final uri = Uri.http(url, '$reviewEndpoint/$id');
      final response = await http.delete(uri);

      if (response.statusCode != 204) {
        throw Exception(
            'Failed to delete review: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      return Future.error('Error deleting review: $e');
    }
  }
}
