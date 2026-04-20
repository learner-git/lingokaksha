import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/session_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Level badge ──────────────────────────────────────
            _LevelBadge(sessionXp: session.sessionXp)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.1),

            const SizedBox(height: 20),

            // ── Stats grid ───────────────────────────────────────
            Text('This week', style: theme.textTheme.titleLarge)
                .animate()
                .fadeIn(delay: 100.ms),
            const SizedBox(height: 12),
            _StatsGrid(sessionXp: session.sessionXp)
                .animate()
                .fadeIn(delay: 150.ms),

            const SizedBox(height: 24),

            // ── Weekly activity chart ────────────────────────────
            Text('Activity', style: theme.textTheme.titleLarge)
                .animate()
                .fadeIn(delay: 200.ms),
            const SizedBox(height: 12),
            _WeeklyChart().animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 24),

            // ── Skill breakdown ──────────────────────────────────
            Text('Skill breakdown', style: theme.textTheme.titleLarge)
                .animate()
                .fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            _SkillBreakdown().animate().fadeIn(delay: 350.ms),

            const SizedBox(height: 24),

            // ── Recent activity ──────────────────────────────────
            Text('Recent activity', style: theme.textTheme.titleLarge)
                .animate()
                .fadeIn(delay: 400.ms),
            const SizedBox(height: 12),
            _RecentActivity(events: session.sessionEvents)
                .animate()
                .fadeIn(delay: 450.ms),
          ],
        ),
      ),
    );
  }
}

// ── Level Badge ──────────────────────────────────────────────────────────────
class _LevelBadge extends StatelessWidget {
  final int sessionXp;
  const _LevelBadge({required this.sessionXp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Text('🏅', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Level A2.2',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text(
                    '1,240 XP total  ·  340 XP to next level',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.73,
                    backgroundColor: AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.secondary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Grid ───────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final int sessionXp;
  const _StatsGrid({required this.sessionXp});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Streak', 'value': '14 🔥', 'sub': 'days'},
      {'label': 'Words learned', 'value': '342', 'sub': 'vocabulary'},
      {'label': 'Lessons done', 'value': '28', 'sub': 'completed'},
      {'label': 'Quiz accuracy', 'value': '81%', 'sub': 'average'},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: stats.map((s) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s['label']!,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['value']!,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700)),
                  Text(s['sub']!,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Weekly Chart ─────────────────────────────────────────────────────────────
class _WeeklyChart extends StatelessWidget {
  final _data = const [8.0, 12.0, 0.0, 15.0, 10.0, 20.0, 14.0];
  final _days = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 25,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) => Text(
                  _days[v.toInt()],
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: _data.asMap().entries.map((e) {
            final isToday = e.key == 5; // Saturday
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value,
                  color: isToday
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Skill Breakdown ──────────────────────────────────────────────────────────
class _SkillBreakdown extends StatelessWidget {
  final _skills = const [
    {'name': 'Grammar', 'value': 0.72, 'color': AppColors.info},
    {'name': 'Vocabulary', 'value': 0.85, 'color': AppColors.success},
    {'name': 'Listening', 'value': 0.55, 'color': AppColors.warning},
    {'name': 'Writing', 'value': 0.48, 'color': AppColors.error},
    {'name': 'Reading', 'value': 0.68, 'color': AppColors.primary},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: _skills.map((s) {
          final value = s['value'] as double;
          final color = s['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    s['name'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: color.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${(value * 100).round()}%',
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Recent Activity ──────────────────────────────────────────────────────────
class _RecentActivity extends StatelessWidget {
  final List<dynamic> events;
  const _RecentActivity({required this.events});

  @override
  Widget build(BuildContext context) {
    final displayEvents = events.isEmpty
        ? [
            {'type': 'lesson', 'desc': 'Completed A2 Unit 4 Lesson 1', 'xp': 20},
            {'type': 'quiz', 'desc': 'Quiz: 4/5 correct', 'xp': 20},
            {'type': 'vocab', 'desc': 'Reviewed 10 vocab cards', 'xp': 10},
            {'type': 'chat', 'desc': 'Chat session with GermanShikshak', 'xp': 5},
          ]
        : events
            .take(4)
            .map((e) => {
                  'type': e.type,
                  'desc': e.description,
                  'xp': e.xpEarned,
                })
            .toList();

    final icons = {
      'lesson': (Icons.menu_book_rounded, AppColors.primary),
      'quiz': (Icons.psychology_rounded, AppColors.warning),
      'vocab': (Icons.style_rounded, AppColors.secondary),
      'chat': (Icons.chat_bubble_rounded, AppColors.info),
    };

    return Column(
      children: displayEvents.map((e) {
        final type = e['type'] as String;
        final iconData = icons[type] ??
            (Icons.star_rounded, AppColors.primary);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconData.$2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(iconData.$1, color: iconData.$2, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(e['desc'] as String,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${e['xp']} XP',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
