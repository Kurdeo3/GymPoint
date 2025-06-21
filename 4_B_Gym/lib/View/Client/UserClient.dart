import 'package:flutter_application_tugasbesar/view/Entity/User.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

class UserClient {
  static final String url = '10.0.2.2:8000'; 
  static final String userEndpoint = '/api/user';
  static String? token;
  
  static Future<List<User>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, userEndpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<User> find(int id) async {
    try {
      var response = await get(Uri.http(url, '$userEndpoint/show/$id')); 

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return User.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> create(User user) async {
  try {
    final response = await post(
      Uri.http(url, '/api/register'),
      headers: {"Content-Type": "application/json"},
      body: user.toRawJson(),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      final errorMessage = json.decode(response.body)['message'] ?? response.reasonPhrase;
      throw Exception(errorMessage);
    }
  } catch (e) {
    throw Exception('Error during registration: $e');
  }
}

  static Future<User> getCurrentUser () async {
  try {
    if (token == null) {
      throw Exception('Token kosong karena Anda belum login');
    }

    final response = await get(
      Uri.http(url, '/api/user/loginSaatIni'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Token : $token');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('data')) {
        return User.fromJson(responseBody['data']);
      } else {
        throw Exception('Data user tidak ditemukan');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token tidak valid.');
    } else {
      throw Exception('Error tidak diketahui: ${response.body}');
    }

  } catch (e) {
    print('Error dalam getCurrent:User  $e');
    rethrow;
  }
}

  static Future<Response> update(User user) async {
    try {
      var response = await post( 
        Uri.http(url, '/api/update'), 
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', 
        },
        body: user.toRawJson(),
      );

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> destroy(int id) async {
    try {
      var response = await delete(Uri.http(url, '$userEndpoint/delete/$id')); 

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await post(
        Uri.http(url, 'api/login'), 
        body: {
          'username': username,
          'password': password,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseBody.containsKey('detail') && responseBody.containsKey('token')) {
          token = responseBody['token'];
          return responseBody;
        } else {
          throw Exception('Login gagal: Format response tidak valid');
        }
      } else {
        if (response.statusCode == 401 && responseBody['message'] == 'Password tidak tersedia') {
          throw Exception('Password tidak tersedia');
        } else if (response.statusCode == 404 && responseBody['message'] == 'Username tidak tersedia') {
          throw Exception('Username tidak tersedia');
        } else if (responseBody['message'] == 'Username dan Password tidak tersedia') {
          throw Exception('Username dan Password tidak tersedia');
        } else {
          throw Exception(responseBody['message'] ?? 'Login gagal');
        }
      }
    } catch (e) {
      print('Error login: $e');
      throw Exception('Terjadi kesalahan saat login: ${e.toString()}');
    }
  }

  static Future<Response> logout(String token) async {
    try {
      var response = await post(
        Uri.http(url, '/api/logout'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> uploadProfilePicture(File image) async {
    try {
      var request = MultipartRequest(
        'POST',
        Uri.http(url, '/api/user/uploadProfilePicture'), 
      );

      request.headers["Authorization"] = "Bearer $token";

      request.files.add(await MultipartFile.fromPath('profile_picture', image.path));

      var response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to upload profile picture');
      }

      final responseBody = await response.stream.bytesToString();
      print('Response: $responseBody');
    } catch (e) {
      throw Exception('Error uploading profile picture: $e');
    }
  }
}