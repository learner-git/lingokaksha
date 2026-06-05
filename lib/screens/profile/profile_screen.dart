import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_extensions.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    (data['name'] as String?)?.isNotEmpty == true
                        ? (data['name'] as String)[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data['name']?.toString() ?? 'Learner',
                  style: theme.textTheme.headlineMedium,
                ),
                Text(
                  data['email']?.toString() ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _infoTile(context, 'Level', data['level']?.toString() ?? '-'),
                _infoTile(context, 'XP', data['xp']?.toString() ?? '0'),
                _infoTile(
                  context,
                  'Lesson',
                  data['currentLesson']?.toString() ?? '-',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(BuildContext context, String title, String value) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
