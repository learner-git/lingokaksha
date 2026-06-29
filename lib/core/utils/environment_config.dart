import 'package:flutter/foundation.dart';
import 'app_config_stub.dart' if (dart.library.js) 'dart:js' as js;

class EnvironmentConfig {
  static String get apiBaseUrl {
    if (kIsWeb) {
      try {
        // We use a dynamic lookup to avoid compile-time issues on non-web platforms
        final dynamic context = js.context;
        final runtimeUrl = context['appConfig']?['apiBaseUrl'];
        if (runtimeUrl != null && runtimeUrl != "API_BASE_URL_PLACEHOLDER") {
          return runtimeUrl;
        }
      } catch (e) {
        // Fallback
      }
    }

    return const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://192.168.0.244:8000',
    );
  }
}
