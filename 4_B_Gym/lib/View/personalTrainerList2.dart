import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_tugasbesar/view/Entity/PersonalTrainer.dart'; 
import 'package:flutter_application_tugasbesar/view/Client/PersonalTrainerClient.dart'; 
import 'package:flutter_application_tugasbesar/view/personalTrainerDetail.dart';

const baseUrl = 'http://10.0.2.2:8000/';

final personalTrainerProvider = FutureProvider<List<PersonalTrainer>>((ref) async {
  return await PersonalTrainerClient.fetchAll(); 
});

class PersonalTrainerListView2 extends ConsumerWidget {
  const PersonalTrainerListView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final personalTrainerAsyncValue = ref.watch(personalTrainerProvider);

    ref.refresh(personalTrainerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Trainer'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[600],
      body: personalTrainerAsyncValue.when(
        data: (trainers) {
          if (trainers.isEmpty) {
            return Center(
              child: Text(
                "No Personal Trainer",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: trainers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final trainer = trainers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalTrainerDetail(trainer: trainer),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            "$baseUrl${trainer.image}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 130,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trainer.nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trainer.spesialisasi,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${trainer.umur}/${trainer.jenis_kelamin}',
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Rp ${trainer.harga}",
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
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
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            "Error: $error",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}