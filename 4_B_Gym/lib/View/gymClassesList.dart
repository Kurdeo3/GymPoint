import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/personalTrainerDetail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymClasses.dart';
import 'package:flutter_application_tugasbesar/view/Client/GymClassesClient.dart';
import 'package:flutter_application_tugasbesar/view/gymClassDetail.dart';
import 'package:flutter_application_tugasbesar/view/booking.dart' as BookingView;
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';
import 'package:flutter_application_tugasbesar/view/Entity/User.dart' as EntityUser;

const baseUrl = 'http://10.0.2.2:8000/';

final gymClassesProvider = FutureProvider<List<GymClasses>>((ref) async {
  return await GymClassesClient.fetchAll();
});

class GymClassesListView extends ConsumerWidget {
  const GymClassesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final gymClassesAsyncValue = ref.watch(gymClassesProvider);

    ref.refresh(gymClassesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[600],
      body: gymClassesAsyncValue.when(
        data: (gymClasses) {
          if (gymClasses.isEmpty) {
            return Center(child: Text("No Gym Class", style: TextStyle(color: Colors.white, fontSize: 18)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: gymClasses.length,
            itemBuilder: (context, index) {
              final gymClass = gymClasses[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GymClassDetail(gymClass: gymClass),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          "$baseUrl${gymClass.image}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 160,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: gymClass.nama_kelas + " ",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "with ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: gymClass.instruktur,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${gymClass.kapasitas} Slots",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${gymClass.hari}, ${gymClass.jam.hour.toString().padLeft(2, '0')}:${gymClass.jam.minute.toString().padLeft(2, '0')} (${gymClass.durasi} menit)",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Harga: Rp ${gymClass.harga}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.green[400],
                                  radius: 16,
                                  child: IconButton(
                                  icon :const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                  onPressed: () async {
                                    try {

                                      EntityUser .User? user = await UserClient.getCurrentUser ();
                                      bool isSkipped = user == null; 

                                      if (isSkipped) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Anda harus login untuk melakukan booking.')),
                                        );
                                        return; 
                                      }

                                      if (gymClass.kapasitas > 0 ) {
                                      EntityUser.User user = await UserClient.getCurrentUser();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookingView.BookingPage(
                                            bookingItems: [
                                              {
                                                'jenis_layanan': 'Gym Class',
                                                'ID_GymClass': gymClass.id.toString(),
                                                'nama_kelas': gymClass.nama_kelas,
                                                'instruktur': gymClass.instruktur,
                                                'harga': gymClass.harga.toString(),
                                              }
                                            ],
                                            jenisLayananBooking: "Gym Class", 
                                            user: user,
                                            gymClasses: gymClass, 
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Kelas sudah penuh')),
                                      );
                                    }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error fetching user: $e')),
                                      );
                                    }
                                },
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
        loading: () => Center(child: CircularProgressIndicator ()),
        error: (error, stack) => Center(child: Text("Error: $error", style: TextStyle(color: Colors.red))),
      ),
    );
  }
}