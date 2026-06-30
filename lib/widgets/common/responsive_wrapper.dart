import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const AppResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // On native Mobile (Android/iOS), don't add any extra logic
    if (!kIsWeb) return child;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          // Allow full width on mobile/tablet, but cap it for ultra-wide desktop monitors
          constraints: const BoxConstraints(maxWidth: 1200),
          child: child,
        ),
      ),
    );
  }
}
