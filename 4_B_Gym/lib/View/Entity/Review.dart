import 'dart:convert';

class Review {
  final int? id;
  final String? ulasan;
  final int? rating;
  final int? ID_User;
  final int? ID_Booking;

  Review({
    this.id,
    required this.ulasan,
    required this.rating,
    required this.ID_User,
    required this.ID_Booking,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'ulasan': ulasan,
      'rating': rating,
      'ID_User': ID_User,
      'ID_Booking': ID_Booking,
    };

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      ulasan: json['ulasan'],
      rating: json['rating'],
      ID_User: json['ID_User'],
      ID_Booking: json['ID_Booking'],
    );
  }

  factory Review.fromRawJson(String str) {
    final Map<String, dynamic> jsonData = json.decode(str);
    return Review.fromJson(jsonData);
  }

  String toRawJson() {
    final Map<String, dynamic> jsonData = toJson();
    return json.encode(jsonData);
  }
}
