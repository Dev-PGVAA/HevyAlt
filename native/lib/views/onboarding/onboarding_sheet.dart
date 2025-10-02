import 'package:flutter/material.dart';

import 'profile_details_view.dart';

class OnboardingSheet extends StatelessWidget {
  const OnboardingSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const OnboardingSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: const ProfileDetailsView(),
    );
  }
}
