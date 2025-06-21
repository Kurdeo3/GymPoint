import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymEquipment.dart';
import 'package:flutter_application_tugasbesar/view/booking.dart';

const baseUrl = 'http://10.0.2.2:8000/';

class GymEquipmentDetail extends StatelessWidget {
  final GymEquipment equipment;

  const GymEquipmentDetail({Key? key, required this.equipment}) : super(key: key);

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
                  color: Colors.white),
            ),
            Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
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
        title: Text(equipment.nama_alat),
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
                "$baseUrl${equipment.image}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              const SizedBox(height: 16),

              Text(
                equipment.nama_alat,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              _buildDetailField('Jumlah Alat', equipment.jumlah.toString()),
              _buildDetailField('Jenis Alat', equipment.jenis_alat.toString()),
              _buildDetailField('Harga', equipment.harga.toString()),
              const Divider(thickness: 1, color: Colors.white),
              const SizedBox(height: 16),

              const Text(
                'Deskripsi',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                equipment.deskripsi,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
