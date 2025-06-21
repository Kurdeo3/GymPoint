import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymClasses.dart';
import 'package:flutter_application_tugasbesar/view/booking.dart';

const baseUrl = 'http://10.0.2.2:8000/';

class GymClassDetail extends StatelessWidget {
  final GymClasses gymClass;

  const GymClassDetail({Key? key, required this.gymClass}) : super(key: key);

  Widget _buildDetailField(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gymClass.nama_kelas),
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
                "$baseUrl${gymClass.image}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              const SizedBox(height: 16),
              Text(
                gymClass.nama_kelas,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailField('Durasi', gymClass.durasi.toString()),
              _buildDetailField('Hari', gymClass.hari.toString()),
              _buildDetailField('Jam', '${gymClass.jam.hour.toString().padLeft(2, '0')}:${gymClass.jam.minute.toString().padLeft(2, '0')}'),
              _buildDetailField('Kapasitas', gymClass.kapasitas.toString()),
              _buildDetailField('Harga', gymClass.harga.toString()),
              _buildDetailField('Jenis kelas', gymClass.jenis_kelas.toString()),
              _buildDetailField('Instruktur', gymClass.instruktur.toString()),
              const Divider(thickness: 1, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                gymClass.deskripsi,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}