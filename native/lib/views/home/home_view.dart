import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        elevation: 0,
        title: const Text('HevyAlt', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthProvider>().logout(),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
      backgroundColor: const Color(0xFF101010),
      body: user == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          width: 64,
                          height: 64,
                          color: Colors.white24,
                          child:
                              (user.avatar != null && user.avatar!.isNotEmpty)
                              ? Image.network(user.avatar!, fit: BoxFit.cover)
                              : const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 32,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
