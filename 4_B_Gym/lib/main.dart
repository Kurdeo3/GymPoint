import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/View/home.dart';
import 'package:flutter_application_tugasbesar/View/login.dart';
import 'package:flutter_application_tugasbesar/View/optionMenu.dart';
import 'package:flutter_application_tugasbesar/view/home_content.dart';
import 'package:flutter_application_tugasbesar/view/profile_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OptionMenu(),
    );
  }
}
