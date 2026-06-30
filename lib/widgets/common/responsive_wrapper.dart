import 'package:flutter/material.dart';

/// A wrapper that ensures the app looks great across all platforms.
/// On Web/Desktop, it allows the app to be fluid and fill the screen,
/// while maintaining accessibility standards.
class AppResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const AppResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // We remove the hard constraints to allow "Full Screen" as requested.
    // Flutter will now naturally fill the browser window.
    return child;
  }
}
