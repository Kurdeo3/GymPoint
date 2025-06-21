import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Berita1 extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  Berita1({Key? key}) : super(key: key);

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
                        'images/berita2.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Ini lah manfaat dari latihan Yoga',
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
                      'Halo sobat GYM POINT, Tahukah kamu kalau YOGA memiliki banyak manfaat, seperti meningkatkan fleksibilitas, kekuatan, dan keseimbangan tubuh. Selain itu, yoga membantu mengurangi stres dan kecemasan melalui pernapasan dan meditasi yang menenangkan. Latihan yoga secara teratur juga dapat meningkatkan fokus serta memberikan rasa tenang dan kesejahteraan mental.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _speak(
                      'Halo sobat GYM POINT, Tahukah kamu kalau YOGA memiliki banyak manfaat, seperti meningkatkan fleksibilitas, kekuatan, dan keseimbangan tubuh. Selain itu, yoga membantu mengurangi stres dan kecemasan melalui pernapasan dan meditasi yang menenangkan. Latihan yoga secara teratur juga dapat meningkatkan fokus serta memberikan rasa tenang dan kesejahteraan mental.',
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
