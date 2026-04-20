import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import '../core/constants/app_constants.dart';

final userDocProvider = StreamProvider((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots();
});

/// 🔥 New Provider to track progress for the SELECTED language
final userProgressProvider = StreamProvider((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  final language = ref.watch(selectedLanguageProvider);
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('progress')
      .doc(language)
      .snapshots();
});

/// Provider to track the currently selected level locally
final selectedLevelProvider = StateProvider<String?>((ref) {
  final progressDoc = ref.watch(userProgressProvider).valueOrNull;
  if (progressDoc != null && progressDoc.exists) {
    return progressDoc.data()?['level'] as String?;
  }
  return 'A1';
});

/// Provider to track the currently selected language
final selectedLanguageProvider = StateProvider<String>((ref) {
  final userDoc = ref.watch(userDocProvider).valueOrNull;
  if (userDoc != null && userDoc.exists) {
    return userDoc.data()?['targetLanguage'] as String? ?? 'german';
  }
  return 'german';
});

