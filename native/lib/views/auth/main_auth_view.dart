import 'package:flutter/material.dart';

import 'auth_type.dart';

class MainAuthView extends StatelessWidget {
  final ValueChanged<AuthType> onTypeChange;

  const MainAuthView({super.key, required this.onTypeChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Google sign-in action
          },
          icon: Image.asset('assets/google_icon.png', width: 24),
          label: const Text(
            "Continue with Google",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withOpacity(0.5))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("or", style: TextStyle(color: Colors.white)),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.5))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onTypeChange(AuthType.register),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8F5C),
                  foregroundColor: const Color(0xFF101010),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onTypeChange(AuthType.login),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
