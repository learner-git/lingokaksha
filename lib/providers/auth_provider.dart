import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_provider.g.dart';

/// 🔥 AUTH STATE STREAM (USED GLOBALLY)
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

/// 🔥 AUTH NOTIFIER
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    /// ✅ FIX: NEVER keep loading here
    final user = FirebaseAuth.instance.currentUser;
    return AsyncValue.data(user);
  }

  /// 🔥 GOOGLE SIGN-IN (WEB SAFE)
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final provider = GoogleAuthProvider();
      final cred = await FirebaseAuth.instance.signInWithPopup(provider);
      final user = cred.user;
      if (user == null) throw Exception('Google sign-in cancelled');

      await _ensureUserDocument(user, name: user.displayName);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 🔥 EMAIL SIGN-IN
  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await _ensureUserDocument(user);
      }
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e, st) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'User not registered. Please sign up first.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later.';
          break;
        default:
          message = e.message ?? 'Login failed';
      }
      state = AsyncValue.error(Exception(message), st);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 🔥 EMAIL SIGN-UP
  Future<void> signUpWithEmail(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      final user = cred.user!;
      await _ensureUserDocument(user, name: name);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 🔥 GUEST LOGIN
  Future<void> signInAnonymously() async {
    state = const AsyncValue.loading();
    try {
      final cred = await FirebaseAuth.instance.signInAnonymously();
      final user = cred.user;
      if (user != null) {
        await _ensureUserDocument(user, name: 'Guest Learner');
      }
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Helper to ensure the user document exists in Firestore
  Future<void> _ensureUserDocument(User user, {String? name}) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      // Create primary user document
      await userRef.set({
        'name': name ?? user.displayName ?? 'Learner',
        'email': user.email ?? 'guest@lingokaksha.com',
        'targetLanguage': 'german', // Default language
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Initialize default language progress in sub-collection
      await userRef.collection('progress').doc('german').set({
        'xp': 0,
        'level': 'A1',
        'currentLesson': 'a1-intro',
        'completedLessons': [],
        'lastAccessed': FieldValue.serverTimestamp(),
      });
    }
  }

  /// UPDATE USER PROGRESS (Multi-language aware)
  Future<void> updateProgress({
    required int xp,
    required String language,
    String? lessonId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final progressRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc(language);

    final updates = <String, dynamic>{
      'xp': FieldValue.increment(xp),
      'lastAccessed': FieldValue.serverTimestamp(),
    };

    if (lessonId != null) {
      updates['currentLesson'] = lessonId;
      updates['completedLessons'] = FieldValue.arrayUnion([lessonId]);
    }

    try {
      await progressRef.update(updates);
    } catch (e) {
      // If document doesn't exist for some reason, create it
      await progressRef.set({
        'xp': xp,
        'level': 'A1',
        'currentLesson': lessonId ?? 'a1-intro',
        'completedLessons': lessonId != null ? [lessonId] : [],
        'lastAccessed': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  ///  FORGOT PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message ?? 'Failed to send reset email');
  }
}

  /// 🔥 LOGOUT
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = const AsyncValue.data(null);
  }
}