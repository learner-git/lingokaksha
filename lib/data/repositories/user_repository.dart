import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/activity_event.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => UserRepository();

class UserRepository {
  final _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: AppConstants.firestoreDatabaseId,
  );
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  String? get _uid => _auth.currentUser?.uid;

  // ── Create / fetch ───────────────────────────────────────────────────────

  Future<UserModel?> fetchCurrentUser() async {
    final uid = _uid;
    if (uid == null) return null;
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson({...doc.data()!, 'uid': uid});
  }

  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateLevels({required String currentLevel, required String targetLevel}) async {
    final uid = _uid;
    if (uid == null) return;
    await _users.doc(uid).update({
      'level': currentLevel,
      'targetLevel': targetLevel,
    });
  }

  Future<void> updateLevel(String level) async {
    final uid = _uid;
    if (uid == null) return;
    await _users.doc(uid).update({'level': level});
  }

  Future<void> updateUserField(String field, dynamic value) async {
    final uid = _uid;
    if (uid == null) return;
    await _users.doc(uid).update({field: value});
  }

  // ── Session flush (batched — called on app background) ────────────────────

  Future<void> flushSession({
    required int xpEarned,
    required List<ActivityEvent> events,
    String? language, // New: support multiple languages
    String? completedLessonId,
    int? quizScore,
    int? quizTotal,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final lang = language ?? AppConstants.defaultLanguage;
    final batch = _db.batch();
    final userRef = _users.doc(uid);
    final langRef = userRef.collection('languages').doc(lang);

    // Atomic XP increment + lastActive
    batch.update(userRef, {
      'xp': FieldValue.increment(xpEarned),
      'lastActive': FieldValue.serverTimestamp(),
      'totalMinutes': FieldValue.increment(1),
    });

    // Language specific stats
    batch.set(langRef, {
      'xp': FieldValue.increment(xpEarned),
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Lesson progress (user_id/languages/german/progress/lesson_id)
    if (completedLessonId != null) {
      batch.set(
        langRef.collection('progress').doc(completedLessonId),
        {
          'completedAt': FieldValue.serverTimestamp(),
          'score': quizScore ?? 0,
          'total': quizTotal ?? 0,
        },
        SetOptions(merge: true),
      );
      
      // Update global completed list (optional, but good for summary)
      batch.update(userRef, {
        'completedLessons': FieldValue.arrayUnion(['$lang:$completedLessonId']),
        'totalLessons': FieldValue.increment(1),
      });
    }

    // Activity log (user_id/languages/german/activity/date)
    if (events.isNotEmpty) {
      final logRef = langRef
          .collection('activity')
          .doc(DateTime.now().toIso8601String().substring(0, 10));
      batch.set(
        logRef,
        {
          'date': FieldValue.serverTimestamp(),
          'events': events.map((e) => e.toJson()).toList(),
          'totalXp': xpEarned,
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }

  // ── Streak calculation ────────────────────────────────────────────────────

  Future<int> computeAndUpdateStreak() async {
    final uid = _uid;
    if (uid == null) return 0;

    final doc = await _users.doc(uid).get();
    if (!doc.exists) return 0;

    final data = doc.data()!;
    final lastActive = (data['lastActive'] as Timestamp?)?.toDate();
    int streak = (data['streak'] as int?) ?? 0;

    final now = DateTime.now();
    if (lastActive == null) {
      streak = 1;
    } else {
      final diff = now.difference(lastActive).inDays;
      if (diff == 0) {
        // Same day — keep streak
      } else if (diff == 1) {
        streak += 1; // Consecutive day
      } else {
        streak = 1; // Streak broken
      }
    }

    await _users.doc(uid).update({'streak': streak});
    return streak;
  }

  // ── Weak topics ───────────────────────────────────────────────────────────

  Future<void> addWeakTopic(String topic) async {
    final uid = _uid;
    if (uid == null) return;
    await _users.doc(uid).update({
      'weakTopics': FieldValue.arrayUnion([topic]),
    });
  }

  Future<void> removeWeakTopic(String topic) async {
    final uid = _uid;
    if (uid == null) return;
    await _users.doc(uid).update({
      'weakTopics': FieldValue.arrayRemove([topic]),
    });
  }

  // ── Analytics snapshot ────────────────────────────────────────────────────

  Stream<Map<String, dynamic>> watchUserStats() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return {};
      return doc.data() ?? {};
    });
  }
}
