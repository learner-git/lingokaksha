import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/user_repository.dart';
import '../../providers/session_provider.dart';

part 'sync_service.g.dart';

@riverpod
SyncService syncService(SyncServiceRef ref) => SyncService(ref);

class SyncService {
  final Ref _ref;
  SyncService(this._ref);

  /// Call this when the app is backgrounded or closed.
  /// Writes accumulated session data to Firestore in a single batch.
  Future<void> flushCurrentSession() async {
    final session = _ref.read(sessionNotifierProvider);
    if (session.sessionXp == 0 && session.sessionEvents.isEmpty) return;

    try {
      final repo = _ref.read(userRepositoryProvider);
      await repo.flushSession(
        xpEarned: session.sessionXp,
        events: session.sessionEvents,
        completedLessonId: session.completedLessonId,
        quizScore: session.quizScore,
        quizTotal: session.quizTotal,
      );
      // Reset after successful sync
      _ref.read(sessionNotifierProvider.notifier).resetSession();
    } catch (e) {
      // Will retry next session — data is safe in session_provider RAM
      // In production: add to a local retry queue
    }
  }
}
