import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Berita2 extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  Berita2({Key? key}) : super(key: key);

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: const Text(
          'News and Insight',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.asset(
                        'images/berita1.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '5 olahraga ini bisa membuat kamu lebih sehat dan mudah untuk di lakukan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Berikut 5 olahraga yang mudah dilakukan dan bermanfaat untuk kesehatan.\n\n'
                      '1. Jalan Kaki : Meningkatkan kebugaran jantung, mengurangi stres, dan mudah dilakukan setiap hari.\n'
                      '2. Jogging : Membakar kalori, memperkuat otot kaki, dan meningkatkan daya tahan tubuh.\n'
                      '3. Senam Aerobik : Menyehatkan jantung, meningkatkan fleksibilitas, dan bisa dilakukan di rumah.\n'
                      '4. Bersepeda : Menjaga kesehatan kardiovaskular dan otot kaki, serta menyenangkan.\n'
                      '5. Yoga : Mengurangi stres, meningkatkan keseimbangan, dan bisa dilakukan di rumah dengan matras.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _speak(
                      'Berikut 5 olahraga yang mudah dilakukan dan bermanfaat untuk kesehatan '
                      'Jalan Kaki : Meningkatkan kebugaran jantung, mengurangi stres, dan mudah dilakukan setiap hari.'
                      'Jogging : Membakar kalori, memperkuat otot kaki, dan meningkatkan daya tahan tubuh.'
                      'Senam Aerobik : Menyehatkan jantung, meningkatkan fleksibilitas, dan bisa dilakukan di rumah.'
                      'Bersepeda : Menjaga kesehatan kardiovaskular dan otot kaki, serta menyenangkan.'
                      'Yoga : Mengurangi stres, meningkatkan keseimbangan, dan bisa dilakukan di rumah dengan matras.'
                      'Olahraga-olahraga ini mudah dilakukan tanpa alat khusus dan membantu menjaga kesehatan tubuh.',
                    ),
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Untuk merasakan manfaat YOGA secara real dan mendalam, jangan lupa untuk join kelas kita ya...',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _speak(
                      'Untuk merasakan manfaat YOGA secara real dan mendalam, jangan lupa untuk join kelas kita ya...',
                    ),
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
