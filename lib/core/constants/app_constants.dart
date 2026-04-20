class AppConstants {
  AppConstants._();

  static const appName = 'LingoKaksha';
  static const appVersion = '1.0.0';

  // API
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    //defaultValue: 'http://127.0.0.1:8000', // Standard for Local Desktop
    defaultValue: 'http://192.168.0.244:8000', // Android Mobile
  );

  // Languages
  static const defaultLanguage = 'german';
  static const supportedLanguages = [
    {'id': 'german', 'name': 'German', 'code': 'de'},
    {'id': 'french', 'name': 'French', 'code': 'fr'},
    {'id': 'spanish', 'name': 'Spanish', 'code': 'es'},
  ];

  // Firebase
  static const firestoreDatabaseId = 'lingo-kaksha';

  // Session
  static const maxChatHistory = 10;
  static const maxContextTokens = 3000;
  static const sessionFlushIntervalSec = 30;

  // Learning
  static const dailyGoalMinutes = 10;
  static const streakResetHour = 4; // 4am local time
  static const xpPerLesson = 20;
  static const xpPerQuizCorrect = 5;
  static const xpPerChatMessage = 1;

  // Levels
  static const levels = ['A1', 'A2', 'B1', 'B2'];

  // Cache durations
  static const grammarCacheDays = 7;
  static const quizCacheHours = 24;
  static const lessonCacheDays = 30;
}
