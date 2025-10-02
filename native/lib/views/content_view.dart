import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth/auth_view.dart';
import 'home/home_view.dart';
import 'onboarding/onboarding_sheet.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  @override
  void initState() {
    super.initState();
    // Показываем onboarding sheet после первой отрисовки, если нужен
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowOnboarding();
    });
  }

  void _checkAndShowOnboarding() {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated && auth.needsProfileCompletion) {
      OnboardingSheet.show(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Проверяем onboarding при изменении состояния аутентификации
    final auth = context.watch<AuthProvider>();
    if (auth.isAuthenticated && auth.needsProfileCompletion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          OnboardingSheet.show(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAuthed = auth.isAuthenticated;

    return Scaffold(
      body: isAuthed
          ? const HomeView()
          : Stack(
              children: [
                Container(color: const Color(0xFF101010)),
                const AuthView(),
              ],
            ),
    );
  }
}
