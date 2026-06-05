import 'package:flutter/services.dart';

/// Centralized haptic feedback for consistent iOS-native feel.
class AppHaptics {
  AppHaptics._();

  static void selection() => HapticFeedback.selectionClick();

  static void light() => HapticFeedback.lightImpact();

  static void medium() => HapticFeedback.mediumImpact();

  static void heavy() => HapticFeedback.heavyImpact();

  /// Tab switches, flashcard ratings, minor confirmations.
  static void tap() => selection();

  /// Correct quiz answer, successful action.
  static void success() => light();

  /// Wrong quiz answer, validation error.
  static void error() => heavy();

  /// Mic start/stop, session start/end.
  static void action() => medium();
}
