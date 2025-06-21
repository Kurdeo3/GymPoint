import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/historyClass.dart';
import 'package:flutter_application_tugasbesar/view/historyGymEquipment.dart';
import 'package:flutter_application_tugasbesar/view/historyPersonalTrainer.dart';
import 'package:flutter_application_tugasbesar/view/Client/HistoryClient.dart';
import 'package:flutter_application_tugasbesar/view/Entity/History.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const baseUrl = 'http://10.0.2.2:8000/';

final historyGymEquipmentProvider = FutureProvider<List<dynamic>>((ref) async {
  return await Historyclient.fetchHistoriesByServiceType('Gym Equipment');
});

class HistoryGymEquipmentPage extends ConsumerWidget {
  const HistoryGymEquipmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsyncValue = ref.watch(historyGymEquipmentProvider);
    ref.refresh(historyGymEquipmentProvider);
    return Scaffold(
      body: historyAsyncValue.when(
        data: (histories) {
          if (histories.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada History untuk Gym Equipment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

            return ListView.builder(
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final item = histories[index];

                final gymEquipment = item['booking']?['gym_equipment'] ?? {};
                final nama_alat = gymEquipment['nama_alat'] ?? 'Alat Tidak Tersedia';
                final harga = gymEquipment['harga']?.toString() ?? '0';
                final image = gymEquipment['image'] ?? 'images/default_trainer.png';
                final tanggalBooking = item['tanggal_booking'] ?? DateTime.now().toIso8601String();

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            '$baseUrl$image',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'images/default_trainer.png', 
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nama_alat,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Gym Equipment',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rp ${NumberFormat('#,###').format(double.parse(harga))}/Bulan',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(DateTime.parse(tanggalBooking)),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.grey[600],
    );
  }
}


