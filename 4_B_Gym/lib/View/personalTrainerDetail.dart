import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/Entity/PersonalTrainer.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';
import 'package:flutter_application_tugasbesar/view/Entity/User.dart' as EntityUser;
import 'package:flutter_application_tugasbesar/view/booking.dart' as BookingView;

const baseUrl = 'http://10.0.2.2:8000/';

List<Map<String, String>> bookingItems = [];

class PersonalTrainerDetail extends StatelessWidget {
  final PersonalTrainer trainer;
  const PersonalTrainerDetail({Key? key, required this.trainer}) : super(key: key);

  Widget _buildDetailField(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: \n$value',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trainer.nama),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[600],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "$baseUrl${trainer.image}",
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: 16),
              Text(
                trainer.nama,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              _buildDetailField('Umur', trainer.umur.toString()), 
              _buildDetailField('No Telepon', trainer.no_telp.toString()),
              _buildDetailField('Jenis Kelamin', trainer.jenis_kelamin.toString()),
              _buildDetailField('Spesialisasi', trainer.spesialisasi),
              _buildDetailField('Harga', trainer.harga.toString()),

              ElevatedButton(
                onPressed: () async {

                EntityUser .User? user = await UserClient.getCurrentUser ();
                    bool isSkipped = user == null; 

                if (isSkipped) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Anda harus login untuk melakukan booking.')),
                  );
                  return; 
                }
                  
                try {
                  print('Trainer ID: ${trainer.id}');
                  print('Trainer Nama: ${trainer.nama}');
                  print('Trainer Spesialisasi: ${trainer.spesialisasi}');
                  print('Trainer Harga: ${trainer.harga}');
                  EntityUser.User user = await UserClient.getCurrentUser();
                  if (user.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User ID tidak ditemukan')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingView.BookingPage(
                        bookingItems: [
                          {
                            'jenis_layanan': 'Personal Trainer',
                            'ID_PersonalTrainer': trainer.id.toString(),
                            'nama': trainer.nama,
                            'spesialisasi': trainer.spesialisasi,
                            'harga': trainer.harga.toString(),
                          }
                        ],
                        jenisLayananBooking: "Personal Trainer", 
                        user: user,
                        personalTrainer:trainer,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error fetching user: $e')),
                  );
                }
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Booking',
                  style: TextStyle(
                    color: Colors.white,
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