import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/booking.dart';
import 'package:flutter_application_tugasbesar/view/personalTrainerDetail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_tugasbesar/view/gymEquipmentDetail.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymEquipment.dart';
import 'package:flutter_application_tugasbesar/view/Client/GymEquipmentClient.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';
import 'package:flutter_application_tugasbesar/view/Entity/User.dart' as EntityUser;
import 'package:flutter_application_tugasbesar/view/booking.dart' as BookingView;

const baseUrl = 'http://10.0.2.2:8000/';

final gymEquipmentProvider = FutureProvider<List<GymEquipment>>((ref) async {
  return await GymEquipmentClient.fetchAll();
});

class GymEquipmentListView2 extends ConsumerWidget {
  const GymEquipmentListView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    
    final gymEquipmentAsyncValue = ref.watch(gymEquipmentProvider);

    ref.refresh(gymEquipmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Equipment'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[600],
      body: gymEquipmentAsyncValue.when(
        data: (equipments) {
          if (equipments.isEmpty) {
            return Center(
              child: Text(
                "No Gym Equipment",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: equipments.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.77,
              ),
              itemBuilder: (context, index) {
                final equipment = equipments[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GymEquipmentDetail(equipment: equipment),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                "$baseUrl${equipment.image}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 130,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        equipment.nama_alat,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${equipment.jumlah} alat",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    equipment.jenis_alat,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rp ${equipment.harga}",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.green[400],
                                        radius: 16,
                                        child: IconButton( 
                                        icon: const Icon(
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

                                          if (equipment.jumlah > 0 ) {
                                          EntityUser.User user = await UserClient.getCurrentUser();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BookingView.BookingPage(
                                                bookingItems: [
                                                  {
                                                    'jenis_layanan': 'Gym Equipment',
                                                    'ID_Equipment': equipment.id.toString(),
                                                    'nama_alat': equipment.nama_alat,
                                                    'jenis_alat': equipment.jenis_alat,
                                                    'jumlah': equipment.jumlah.toString(),
                                                    'harga': equipment.harga.toString(),
                                                  }
                                                ],
                                                jenisLayananBooking: "Gym Equipment", 
                                                user: user,
                                                gymEquipment: equipment,
                                              ),
                                            ),
                                          );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Equipment sudah habis')),
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
                    ],
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
