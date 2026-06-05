import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import 'app_svg.dart';

/// Material-styled Google sign-in button with the official multicolor logo.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppSvg(
                    asset: AppAssets.logoGoogle,
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Continue with Google',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
