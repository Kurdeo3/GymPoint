import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/Entity/Review.dart';
import 'package:flutter_application_tugasbesar/view/Client/ReviewClient.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';

const baseUrl = 'http://10.0.2.2:8000/';

class ReviewPersonalTrainerPage extends StatefulWidget {
  final String trainerName;
  final String specialization;
  final int age;
  final String gender;
  final String imageUrl;
  final int ID_Booking;
  final int ID_User;

  const ReviewPersonalTrainerPage({
    Key? key,
    required this.trainerName,
    required this.specialization,
    required this.age,
    required this.gender,
    required this.imageUrl,
    required this.ID_Booking,
    required this.ID_User,
  }) : super(key: key);

  @override
  State<ReviewPersonalTrainerPage> createState() =>
      _ReviewPersonalTrainerPageState();
}

class _ReviewPersonalTrainerPageState extends State<ReviewPersonalTrainerPage> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReview() async {
    String reviewText = _reviewController.text;

    if (_rating == 0.0 || reviewText.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Rating dan ulasan tidak boleh kosong!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final review = Review(
        ulasan: reviewText,
        rating: _rating.toInt(),
        ID_User: widget.ID_User, 
        ID_Booking: widget.ID_Booking, 
      );

    if (UserClient.token == null) {
      throw Exception('Token tidak valid. Silakan login kembali.');
    }
      await ReviewClient.create(review);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Ulasan berhasil disimpan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); 
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Gagal menyimpan ulasan: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Personal Trainer'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[700],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imageUrl,
                      width: 120,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trainerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.specialization,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${widget.age} / ${widget.gender}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Rating',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.yellow[700],
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 36),
              const Text(
                'Ulasan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText:
                      'Berikan ulasan tentang Personal Trainer kamu ini...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
