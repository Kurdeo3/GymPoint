import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymClasses.dart';
import 'package:flutter_application_tugasbesar/view/Entity/GymEquipment.dart';
import 'package:flutter_application_tugasbesar/view/Entity/PersonalTrainer.dart';
import 'package:flutter_application_tugasbesar/view/Client/PersonalTrainerClient.dart';
import 'package:flutter_application_tugasbesar/view/register.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter_application_tugasbesar/View/previewScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_tugasbesar/view/Entity/User.dart';
import 'package:flutter_application_tugasbesar/view/Client/BookingClient.dart';
import 'package:flutter_application_tugasbesar/view/Entity/Booking.dart';
import 'package:flutter_application_tugasbesar/view/Client/GymClassesClient.dart';
import 'package:flutter_application_tugasbesar/view/Client/GymEquipmentClient.dart';

class BookingPage extends StatefulWidget {
  final List<Map<String, String>> bookingItems;
  final String jenisLayananBooking;
  final User user;
  final GymClasses? gymClasses;
  final GymEquipment? gymEquipment;
  final PersonalTrainer? personalTrainer;

  const BookingPage({Key? key, required this.bookingItems, required this.jenisLayananBooking, required this.user, this.gymClasses, this.gymEquipment, this.personalTrainer}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<bool> checkKapasitasDanJumlah() async {
    if ((widget.jenisLayananBooking == 'Gym Class' && widget.gymClasses != null)){
      if(widget.gymClasses!.kapasitas <=0){
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Booking Gagal'),
              content: Text('Kelas sudah penuh. Tidak dapat melakukan booking.'),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                  ), 
              ],
            );
          },
        );
        return false;
      }
      widget.gymClasses!.kapasitas -= 1;
      return true;
    } else if ((widget.jenisLayananBooking == 'Gym Equipment' && widget.gymEquipment != null)){
      if(widget.gymEquipment!.jumlah <=0){
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Booking Gagal'),
              content: Text('Equipment sudah habis. Tidak dapat melakukan booking.'),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                  ), 
              ],
            );
          },
        );
        return false;
      }
      widget.gymEquipment!.jumlah -= 1;
      return true;
    } else if (widget.jenisLayananBooking == 'Personal Trainer' && widget.personalTrainer != null){
      return true;
    }
    return false;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> createPDF() async {
  final pdf = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);

  final userData = {
    'nama': widget.user.nama,
    'email': widget.user.email,
    'notelp': widget.user.noTelp,
  };

  final qrValidationMessage = "Berhasil melakukan booking pada tanggal: $formattedDate \natas nama: ${userData['nama']}";

  final robotoRegular = pw.Font.ttf(await rootBundle.load('fonts/Roboto-Regular.ttf'));
  final robotoBold = pw.Font.ttf(await rootBundle.load('fonts/Roboto-Bold.ttf'));
  final imageLogo = (await rootBundle.load("images/blackLogo.png")).buffer.asUint8List();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(pw.MemoryImage(imageLogo), width: 100, height: 100),
              pw.SizedBox(height: 30),
              pw.Text('Bill To', style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, font: robotoBold)),
              pw.Text('Nama: ${userData['nama']}', style: pw.TextStyle(fontSize: 20, font: robotoRegular)),
              pw.Text('Email: ${userData['email']}', style: pw.TextStyle(fontSize: 20, font: robotoRegular)),
              pw.Text('Nomor Telepon: ${userData['notelp']}', style: pw.TextStyle(fontSize: 20, font: robotoRegular)),
              pw.SizedBox(height: 20),
              pw.Text('Tanggal Booking: ${selectedDate != null ? formatDate(selectedDate!) : 'Tidak ada tanggal'}', style: pw.TextStyle(font: robotoRegular)),
              pw.SizedBox(height: 20),

              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColor.fromHex('#FFBD59')),
                    children: _getTableHeaders(robotoBold),
                  ),
                  ...widget.bookingItems.map((item) {
                    return pw.TableRow(
                      children: _getTableRow(item, robotoRegular),
                    );
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: robotoBold)),
                  pw.Text(
                    'Rp. ${widget.bookingItems.map((item) => item['harga'] ?? item['harga'])
                          .join()
                          .replaceAll(RegExp(r'[^0-9]'), '')}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: robotoBold),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),

              barcodeQR(qrValidationMessage),
            ],
          ),
        ];
      },
    ),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(doc: pdf),
    ),
  );
}

  List<pw.Widget> _getTableHeaders(pw.Font font) {
    switch (widget.jenisLayananBooking) {
      case 'Gym Class':
        return [
          pw.Text('Nama Kelas', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
          pw.Text('Instruktur', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
          pw.Text('Harga', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
        ];
      case 'Gym Equipment':
        return [
          pw.Text('Nama Alat', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
          pw.Text('Jenis Alat', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
          pw.Text('Harga', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
        ];
      default: 
        return [
          pw.Text('Nama', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
          pw.Text('Spesialisasi', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
          pw.Text('Harga', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font), textAlign: pw.TextAlign.center),
        ];
    }
  }

  List<pw.Widget> _getTableRow(Map<String, String> item, pw.Font font) {
    switch (widget.jenisLayananBooking) {
      case 'Gym Class':
        return [
          pw.Text(item['nama_kelas'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
          pw.Text(item['instruktur'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
          pw.Text(item['harga'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
        ];
      case 'Gym Equipment':
        return [
          pw.Text(item['nama_alat'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
          pw.Text(item['jenis_alat'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
          pw.Text(item['harga'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
        ];
      default: 
        return [
          pw.Text(item['nama'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
          pw.Text(item['spesialisasi'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
          pw.Text(item['harga'] ?? '', style: pw.TextStyle(font: font), textAlign: pw.TextAlign.center),
        ];
    }
  }

pw.Widget barcodeQR(String id) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: pw.Center(
      child: pw.BarcodeWidget(
        barcode: pw.Barcode.qrCode(
          errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high,
        ),
        data: id,
        width: 150, 
        height: 150,
      ),
    ),
  );
}

  void removeAllBookings() {
    setState(() {
      widget.bookingItems.clear();
    });
  }

  void errorHandlingDate(BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal Bookig'),
          content: Text('Silahkan input Tanggal Booking terlebih dahulu'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
            child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void errorHandlingLayanan(BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal Bookig'),
          content: Text('Silahkan pilih Layanan Booking terlebih dahulu'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
            child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
  int totalPrice = int.parse(
    widget.bookingItems.map((item) => item['harga'] ?? item['harga'])
    .join()
    .replaceAll(RegExp(r'[^0-9]'), '')
  );

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[600],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
              SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.jenisLayananBooking == 'Gym Class' ? 'Nama Kelas' : widget.jenisLayananBooking == 'Gym Equipment' ? 'Nama Alat' : 'Nama',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text( widget.jenisLayananBooking == 'Gym Class' ? 'Instruktur' : widget.jenisLayananBooking == 'Gym Equipment' ? 'Jenis Alat' : 'Spesialisasi',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Harga', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(color: Colors.grey, thickness: 1),
                        SizedBox(height: 4),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: widget.bookingItems.map((item) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Text(
                                    widget.jenisLayananBooking == 'Gym Class' ? (item['nama_kelas'] ?? '')
                                    : widget.jenisLayananBooking == 'Gym Equipment' ? (item['nama_alat'] ?? '')
                                    : (item['nama'] ?? ''),
                                    style: TextStyle(fontSize: 12), 
                                  ),
                                  Text(
                                    widget.jenisLayananBooking == 'Gym Class' ? (item['instruktur'] ?? '')
                                      : widget.jenisLayananBooking == 'Gym Equipment' ? (item['jenis_alat'] ?? '')
                                      : (item['spesialisasi'] ?? ''),
                                    style: TextStyle(fontSize: 12), 
                                  ),
                                  Text(
                                    item['harga']!,
                                    style: TextStyle(fontSize: 12), 
                                  ),
                                ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
          SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total', 
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Rp. $totalPrice',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
  
          SizedBox(height: 16),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tanggal booking',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onTap: () => selectDate(context),
              controller: TextEditingController(
                text: selectedDate != null ? formatDate(selectedDate!) : '',
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
              if (selectedDate == null) {
                errorHandlingDate(context); 
              } else if (widget.bookingItems.isEmpty){
                errorHandlingLayanan(context);
              } else {
                bool validasiBooking = await checkKapasitasDanJumlah();
                if (!validasiBooking) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tidak dapat melakukan booking.')),
                  );
                  return;
                }

                try{
                  List<Booking> bookings = widget.bookingItems.map((item) {
                  Booking booking = Booking(
                    ID_User: widget.user.id!, 
                    date: selectedDate!,
                    jenis_layanan: widget.jenisLayananBooking,
                    harga: double.parse(item['harga']!.replaceAll(RegExp(r'[^0-9]'), '')),
                  );

                  switch (widget.jenisLayananBooking) {
                    case 'Personal Trainer':
                      booking.ID_PersonalTrainer = int.parse(item['ID_PersonalTrainer'] ?? '0');
                      break;
                    case 'Gym Equipment':
                      booking.ID_Equipment = int.parse(item['ID_Equipment'] ?? '0');
                      break;
                    case 'Gym Class':
                      booking.ID_GymClass = int.parse(item['ID_GymClass'] ?? '0');
                      break;
                    default:
                      throw Exception('Jenis layanan tidak valid');
                  }

                  return booking;
                }).toList();
                    for (var booking in bookings) {
                      await Bookingclient.create(booking);
                    }

                    if (widget.jenisLayananBooking == 'Gym Class' && widget.gymClasses != null) {
                      await GymClassesClient.updateKapasitas(widget.gymClasses!.id, widget.gymClasses!.kapasitas);
                    } else if (widget.jenisLayananBooking == 'Gym Equipment' && widget.gymEquipment != null) {
                      await GymEquipmentClient.updateJumlah(widget.gymEquipment!.id, widget.gymEquipment!.jumlah);
                    }

                    await createPDF(); 

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking berhasil dibuat')),
                    );
                } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat booking: $e')),
                  );
                }
              }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Booking', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
