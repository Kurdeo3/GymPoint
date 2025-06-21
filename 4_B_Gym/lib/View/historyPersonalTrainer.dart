import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/historyClass.dart';
import 'package:flutter_application_tugasbesar/view/historyGymEquipment.dart';
import 'package:flutter_application_tugasbesar/view/reviewPersonalTrainer.dart';
import 'package:flutter_application_tugasbesar/view/Client/HistoryClient.dart';
import 'package:flutter_application_tugasbesar/view/Entity/History.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const baseUrl = 'http://10.0.2.2:8000/';

final historyPersonalTrainerProvider = FutureProvider<List<dynamic>>((ref) async {
  return await Historyclient.fetchHistoriesByServiceType('Personal Trainer');
});

class HistoryPersonalTrainer extends ConsumerWidget {
const HistoryPersonalTrainer({Key? key}) : super(key: key);

@override
Widget build(BuildContext context, WidgetRef ref) {
  final historyAsyncValue = ref.watch(historyPersonalTrainerProvider);
  ref.refresh(historyPersonalTrainerProvider);
  return Scaffold(
    body: historyAsyncValue.when(
      data: (histories) {
        if (histories.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada History untuk Personal Trainer',
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

            final personalTrainer = item['booking']?['personal_trainer'] ?? {};
            final nama = personalTrainer['nama'] ?? 'Nama Tidak Tersedia';
            final harga = personalTrainer['harga']?.toString() ?? '0';
            final image = personalTrainer['image'] ?? 'images/default_trainer.png';
            final tanggalBooking = item['tanggal_booking'] ?? DateTime.now().toIso8601String();

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
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
                                nama,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Personal Trainer',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Rp ${NumberFormat('#,###').format(double.parse(harga))}/Bulan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final personalTrainer = item['booking']?['personal_trainer'] ?? {};
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewPersonalTrainerPage(
                                      trainerName: personalTrainer['nama'] ?? 'Nama Tidak Tersedia',
                                      specialization: personalTrainer['spesialisasi'] ?? 'Tidak ada spesialisasi',
                                      age: personalTrainer['umur'] is int 
                                          ? personalTrainer['umur'] 
                                          : int.tryParse(personalTrainer['umur']?.toString() ?? '0') ?? 0,
                                      gender: personalTrainer['jenis_kelamin'] ?? 'Tidak diketahui',
                                      imageUrl: '$baseUrl${personalTrainer['image'] ?? 'images/default_trainer.png'}',
                                      ID_Booking: int.tryParse(item['id']?.toString() ?? '0') ?? 0,  
                                      ID_User: int.tryParse(item['user']?['id']?.toString() ?? '0') ?? 0, 
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Review',
                                style: TextStyle(
                                  fontSize: 14, 
                                  color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(DateTime.parse(tanggalBooking)),
                              style: TextStyle(
                                fontSize: 14, 
                                color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
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