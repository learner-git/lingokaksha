import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class ApiService {
  // Use the central API URL from AppConstants
  static String get baseUrl => AppConstants.apiBaseUrl;

  /// 🔥 Streaming Tutor API
  static Stream<String> streamMessage({
    required List<Map<String, dynamic>> messages,
    required String level,
    required String topic,
    required String language,
  }) async* {
    // Fixed endpoint path to match backend (/api/tutor)
    final request = http.Request(
      "POST",
      Uri.parse("$baseUrl/api/tutor"),
    );

    request.headers["Content-Type"] = "application/json";

    request.body = jsonEncode({
      "messages": messages,
      "level": level,
      "topic": topic,
      "language": language,
    });

    try {
      // Increased timeout to 60s to account for slow AI generation starts
      final response = await request.send().timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        final errorBody = await response.stream.bytesToString();
        throw Exception("Streaming failed (${response.statusCode}): $errorBody");
      }

      await for (final chunk in response.stream
          .transform(utf8.decoder)
          .timeout(const Duration(seconds: 60))) {
        yield chunk;
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception("Network error: Server is unreachable at $baseUrl. Ensure it's running on 0.0.0.0.");
      }
      throw Exception("Tutor Service Error: $e");
    }
  }
}