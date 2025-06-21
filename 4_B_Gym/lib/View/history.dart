import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_tugasbesar/view/historyPersonalTrainer.dart';
import 'package:flutter_application_tugasbesar/view/historyClass.dart';
import 'package:flutter_application_tugasbesar/view/historyGymEquipment.dart';
import 'package:flutter_application_tugasbesar/view/Client/HistoryClient.dart';
import 'package:flutter_application_tugasbesar/view/Entity/History.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    HistoryPersonalTrainer(),
    HistoryClassPage(),
    HistoryGymEquipmentPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[600],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton("Personal Trainer", 0),
                _buildCategoryButton("Class", 1),
                _buildCategoryButton("Gym Equipment", 2),
              ],
            ),
          ),
          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white, 
        side: BorderSide(
          color: Colors.grey, 
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black87, 
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}