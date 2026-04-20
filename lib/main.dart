import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/constants/hive_keys.dart';
import 'data/models/vocab_card.dart';
import 'data/models/activity_event.dart';
import 'data/repositories/vocab_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar styling
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initialize Hive local DB
  await Hive.initFlutter();
  Hive.registerAdapter(VocabCardAdapter());
  Hive.registerAdapter(ActivityEventAdapter());
  await Hive.openBox<Map>(HiveKeys.vocabulary);
  await Hive.openBox<Map>(HiveKeys.activityLog);
  await Hive.openBox(HiveKeys.userPrefs);
  await Hive.openBox(HiveKeys.lessonCache);
  await Hive.openBox<List>(HiveKeys.chatCache);

  // Seed vocabulary if empty
  final vocabRepo = VocabRepository();
  await vocabRepo.seedSampleVocab();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: LingoKakshaApp(),
    ),
  );
}
