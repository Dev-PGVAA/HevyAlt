import 'package:flutter/material.dart';

import 'auth/auth_view.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFF101010)),
          const AuthView(),
        ],
      ),
    );
  }
}
