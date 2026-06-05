import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../models/chat_message.dart';
import '../models/quiz_model.dart';
import '../models/lesson_model.dart';

part 'gpt_service.g.dart';

@riverpod
GptService gptService(GptServiceRef ref) => GptService(Dio());

/// A professional-grade service for interacting with AI models.
/// All traffic is routed through the secure backend proxy.
/// Pedagogical logic (prompts) is now centralized on the backend.
class GptService {
  final Dio _dio;

  GptService(this._dio) {
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
  }

  // ─── PUBLIC API ──────────────────────────────────────────────────────────

  /// Generates structured lesson content via backend proxy.
  Future<LessonContent> generateLesson({
    required String topic,
    required String level,
    required String language,
  }) async {
    try {
      final raw = await _callBackendProxy('/api/lesson', {
        'topic': topic,
        'level': level,
        'language': language,
      });
      return LessonContent.fromJson(jsonDecode(raw));
    } catch (e) {
      print('Lesson Generation Error: $e');
      return _generateFallbackLesson(topic);
    }
  }

  /// Provides a deeper explanation for a lesson topic via backend proxy.
  Future<LessonClarification> clarifyLesson({
    required String topic,
    required String level,
    required String currentExplanation,
    required String language,
  }) async {
    try {
      final raw = await _callBackendProxy('/api/lesson/clarify', {
        'topic': topic,
        'level': level,
        'current_explanation': currentExplanation,
        'language': language,
      });
      return LessonClarification.fromJson(jsonDecode(raw));
    } catch (e) {
      print('Lesson Clarification Error: $e');
      throw Exception('Failed to get clarification: $e');
    }
  }

  /// Generates a list of quiz questions via backend proxy.
  Future<List<QuizQuestion>> generateQuiz({
    required String topic,
    required String level,
    required String language,
    int count = 5,
  }) async {
    try {
      final bool isExam = topic.contains('Mock-Test');
      final endpoint = isExam ? '/api/exam' : '/api/quiz';
      
      final raw = await _callBackendProxy(endpoint, {
        'topic': topic, 
        'level': level, 
        'count': isExam ? 15 : count,
        'language': language,
      });

      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final list = decoded['questions'] as List;
      return list.map((item) {
        final q = Map<String, dynamic>.from(item as Map);
        q['id'] ??= DateTime.now().millisecondsSinceEpoch.toString();
        return QuizQuestion.fromJson(q);
      }).toList();
    } catch (e) {
      print('Quiz Generation Error: $e');
      rethrow;
    }
  }

  /// Validates grammar via backend proxy.
  Future<GrammarFeedback> checkGrammar(String sentence, String language) async {
    try {
      final raw = await _callBackendProxy('/api/grammar', {
        'sentence': sentence,
        'language': language,
      });
      return GrammarFeedback.fromJson(jsonDecode(raw));
    } catch (_) {
      return GrammarFeedback(correct: true, errors: [], corrected: sentence, explanation: '');
    }
  }

  /// Generates word details with meaning and three examples via backend proxy.
  Future<Map<String, dynamic>> getWordDetails({
    required String word,
    required String language,
    required String level,
  }) async {
    try {
      final raw = await _callBackendProxy('/api/word-details', {
        'word': word,
        'language': language,
        'level': level,
      });
      return jsonDecode(raw);
    } catch (e) {
      print('Word Details Error: $e');
      throw Exception('Failed to get word details: $e');
    }
  }

  /// Analyzes voice input via backend proxy (Whisper + LLM).
  Future<Map<String, dynamic>> analyzeVoice({
    required String audioPath,
    required String language,
    required String level,
    String mode = 'normal',
    String? expectedText,
    List<Map<String, String>>? history,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioPath, filename: 'audio.m4a'),
      });

      final response = await _dio.post(
        '${AppConstants.apiBaseUrl}/api/voice-analysis',
        data: formData,
        queryParameters: {
          'language': language,
          'level': level,
          'mode': mode,
          if (expectedText != null) 'expected_text': expectedText,
          if (history != null) 'history': jsonEncode(history),
        },
      );
      
      return response.data;
    } catch (e) {
      print('Voice Analysis Error: $e');
      throw Exception('Failed to analyze voice: $e');
    }
  }

  /// Starts a voice session with an opening line.
  Future<String> startVoiceSession({
    required String mode,
    required String language,
    required String level,
  }) async {
    try {
      final response = await _dio.post(
        '${AppConstants.apiBaseUrl}/api/voice-start',
        data: {
          'mode': mode,
          'language': language,
          'level': level,
        },
      );
      return response.data['text'] ?? 'Hello!';
    } catch (e) {
      print('Voice Start Error: $e');
      return 'Hello! Let\'s begin.';
    }
  }

  // ─── PRIVATE NETWORK HELPERS ──────────────────────────────────────────────

  Future<String> _callBackendProxy(String path, Map<String, dynamic> body) async {
    final url = '${AppConstants.apiBaseUrl}$path';
    try {
      final response = await _dio.post(url, data: body);
      if (response.data is Map) return jsonEncode(response.data);
      return response.data.toString();
    } on DioException catch (e) {
      String errorMessage = 'Backend Proxy Error ($path): ${e.message}';
      if (e.response?.statusCode == 502) {
        errorMessage = 'AI Service Unavailable (502). The server is running but the AI providers failed to respond. URL: $url';
      } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.connectionError) {
        errorMessage = 'Cannot reach server at $url. Check if the backend is running and the IP is correct.';
      }
      throw Exception(errorMessage);
    }
  }

  LessonContent _generateFallbackLesson(String topic) {
    return LessonContent(
      title: topic.toUpperCase(),
      explanation: [
        LessonSegment(targetText: 'Error.', english: 'Unable to load lesson.')
      ],
      dialogue: [],
      examples: [],
      practiceQuestions: [],
    );
  }
}

class GrammarFeedback {
  final bool correct;
  final List<String> errors;
  final String corrected;
  final String explanation;

  GrammarFeedback({
    required this.correct,
    required this.errors,
    required this.corrected,
    required this.explanation,
  });

  factory GrammarFeedback.fromJson(Map<String, dynamic> json) => GrammarFeedback(
        correct: json['correct'] as bool? ?? true,
        errors: List<String>.from(json['errors'] as List? ?? []),
        corrected: json['corrected'] as String? ?? '',
        explanation: json['explanation'] as String? ?? '',
      );
}
