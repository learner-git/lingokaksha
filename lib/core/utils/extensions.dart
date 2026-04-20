import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(this);

  bool get isValidPassword => length >= 6;

  String get initials {
    final parts = trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Truncates to [maxLength] with ellipsis
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}…';
}

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String get relativeLabel {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    final diff = DateTime.now().difference(this).inDays;
    if (diff < 7) return '$diff days ago';
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';
  }

  String get timeLabel {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Number of full days until this date
  int get daysUntil => difference(DateTime.now()).inDays;
}

extension IntExtensions on int {
  String get xpLabel => '+$this XP';

  String get minuteLabel => '$this min';

  /// e.g. 1240 → "1,240"
  String get formatted {
    if (this < 1000) return toString();
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  /// Level progress color
  Color get levelColor {
    if (this < 500) return AppColors.levelA1;
    if (this < 1500) return AppColors.levelA2;
    if (this < 3000) return AppColors.levelB1;
    return AppColors.levelB2;
  }
}

extension DoubleExtensions on double {
  /// 0.72 → "72%"
  String get percentLabel => '${(this * 100).round()}%';
}

extension ListExtensions<T> on List<T> {
  List<T> safeSublist(int start, [int? end]) {
    final s = start.clamp(0, length);
    final e = (end ?? length).clamp(s, length);
    return sublist(s, e);
  }

  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
}
