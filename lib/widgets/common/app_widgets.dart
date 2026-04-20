import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_colors.dart';

// ── AppButton — animated primary button ──────────────────────────────────────

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final bool outlined;
  final IconData? icon;
  final Color? color;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.outlined = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;

    return SizedBox(
      width: width ?? double.infinity,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: loading ? null : onTap,
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : (icon != null ? Icon(icon) : const SizedBox.shrink()),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: bg,
                side: BorderSide(color: bg, width: 1.5),
              ),
            )
          : ElevatedButton.icon(
              onPressed: loading ? null : onTap,
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : (icon != null
                      ? Icon(icon, color: Colors.white)
                      : const SizedBox.shrink()),
              label: Text(label),
              style: ElevatedButton.styleFrom(backgroundColor: bg),
            ),
    );
  }
}

// ── LoadingOverlay ────────────────────────────────────────────────────────────

class LoadingOverlay extends StatelessWidget {
  final String? message;
  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(message!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms);
  }
}

// ── InlineLoader ──────────────────────────────────────────────────────────────

class InlineLoader extends StatelessWidget {
  final String? message;
  const InlineLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── ErrorView ─────────────────────────────────────────────────────────────────

class ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const ErrorView({
    super.key,
    this.message,
    this.onRetry,
    this.retryLabel = 'Try again',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text('Something went wrong',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18)),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── XP Badge ─────────────────────────────────────────────────────────────────

class XpBadge extends StatelessWidget {
  final int xp;
  const XpBadge({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Text(
        '+$xp XP',
        style: const TextStyle(
          color: AppColors.secondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Level chip ────────────────────────────────────────────────────────────────

class LevelChip extends StatelessWidget {
  final String level;
  const LevelChip({super.key, required this.level});

  Color get _color => switch (level) {
        'A1' => AppColors.levelA1,
        'A2' => AppColors.levelA2,
        'B1' => AppColors.levelB1,
        'B2' => AppColors.levelB2,
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}
