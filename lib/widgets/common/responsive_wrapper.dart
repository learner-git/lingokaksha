import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const AppResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // If not web, just return the child normally
    if (!kIsWeb) return child;

    return Container(
      color: const Color(0xFFF5F7FA), // Neutral background color for the "desk"
      child: Center(
        child: ClipRRect(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500), // Standard mobile width
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
