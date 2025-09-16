import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'views/content_view.dart';

class HevyAltApp extends StatelessWidget {
  const HevyAltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: const Color(0xFF101010),
              scaffoldBackgroundColor: const Color(0xFF101010),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
            ),
            home: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }
        final authProvider = snapshot.data as AuthProvider;
        return ChangeNotifierProvider.value(
          value: authProvider,
          child: MaterialApp(
            theme: ThemeData(
              primaryColor: const Color(0xFF101010),
              scaffoldBackgroundColor: const Color(0xFF101010),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
            ),
            home: const ContentView(),
          ),
        );
      },
    );
  }

  Future<AuthProvider> _init() async {
    final baseUrl = Platform.isAndroid
        ? 'http://10.0.2.2:4200/api'
        : 'http://localhost:4200/api';
    final api = await ApiClient.create(baseUrl: baseUrl);
    final auth = AuthService(api);
    final provider = AuthProvider(authService: auth);
    await provider.initialize();
    return provider;
  }
}
