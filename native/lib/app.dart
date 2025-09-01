import 'package:flutter/material.dart';

import 'views/content_view.dart';

class HevyAltApp extends StatelessWidget {
  const HevyAltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF101010),
        scaffoldBackgroundColor: const Color(0xFF101010),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const ContentView(),
    );
  }
}
