import 'package:flutter/material.dart';

import 'auth_type.dart';
import 'login_view.dart';
import 'main_auth_view.dart';
import 'register_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  AuthType _typeOfAuth = AuthType.main;
  bool _keyboardIsShown = false;

  @override
  Widget build(BuildContext context) {
    // Listen to keyboard visibility changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final newKeyboardState = keyboardHeight > 0;
      if (newKeyboardState != _keyboardIsShown) {
        setState(() => _keyboardIsShown = newKeyboardState);
      }
    });

    return Stack(
      children: [
        Column(
          children: [
            Image.asset(
              'assets/auth-banner.jpg',
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              fit: BoxFit.cover,
            ),
            const Spacer(),
          ],
        ),
        if (_keyboardIsShown)
          Container(color: Colors.black.withValues(alpha: 0.7)),
        Positioned(
          top: 50,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {
                print("Language button pressed");
              },
              padding: const EdgeInsets.all(8),
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              icon: const Icon(Icons.language, color: Colors.white, size: 24),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28.0),
                child: Image.asset('assets/Logo.png', width: 90, height: 90),
              ),
              const SizedBox(height: 8),
              const Text(
                "Welcome to HevyAlt",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFEFEFE),
                ),
              ),
              const Text(
                "Track your workouts, nutrition, and progress all in one place.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 170),
                child: _buildAuthView(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthView() {
    switch (_typeOfAuth) {
      case AuthType.register:
        return RegisterView(
          onTypeChange: (t) => setState(() => _typeOfAuth = t),
        );
      case AuthType.login:
        return LoginView(onTypeChange: (t) => setState(() => _typeOfAuth = t));
      case AuthType.main:
      default:
        return MainAuthView(
          onTypeChange: (t) => setState(() => _typeOfAuth = t),
        );
    }
  }
}
