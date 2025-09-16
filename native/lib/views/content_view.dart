import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth/auth_view.dart';
import 'home/home_view.dart';
import 'onboarding/profile_details_view.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAuthed = auth.isAuthenticated;

    final needsProfile = auth.needsProfileCompletion;

    return Scaffold(
      body: isAuthed
          ? (needsProfile ? const ProfileDetailsView() : const HomeView())
          : Stack(
              children: [
                Container(color: const Color(0xFF101010)),
                const AuthView(),
              ],
            ),
    );
  }
}
