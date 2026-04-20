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
/// All traffic is routed through the secure backend proxy to protect API keys.
class GptService {
  final Dio _dio;

  GptService(this._dio) {
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
  }

  // ─── PUBLIC API ──────────────────────────────────────────────────────────

  /// Handles real-time chat with the AI tutor via backend proxy.
  Future<String> sendTutorMessage({
    required List<ChatMessage> history,
    required String userMessage,
    required String currentTopic,
    required String userLevel,
    required String language,
  }) async {
    final messages = _constructChatMessages(history, userMessage, userLevel, currentTopic, language);

    return await _callBackendProxy('/api/tutor', {
      'messages': messages,
      'level': userLevel,
      'topic': currentTopic,
      'language': language,
    });
  }

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
      final jsonStr = _extractJson(raw);
      return LessonContent.fromJson(jsonDecode(jsonStr));
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

      final jsonStr = _extractJson(raw);
      return LessonClarification.fromJson(jsonDecode(jsonStr));
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
      final actualCount = isExam ? 15 : count;
      final endpoint = isExam ? '/api/exam' : '/api/quiz';
      
      final raw = await _callBackendProxy(endpoint, {
        'topic': topic, 
        'level': level, 
        'count': actualCount,
        'language': language,
      });

      final jsonStr = _extractJson(raw);
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      if (!decoded.containsKey('questions')) {
        throw Exception('Backend response missing "questions" key.');
      }

      final list = decoded['questions'] as List;
      return list.map((item) {
        final q = Map<String, dynamic>.from(item as Map);
        if (q['id'] == null) {
          q['id'] = DateTime.now().millisecondsSinceEpoch.toString();
        }
        return QuizQuestion.fromJson(q);
      }).toList();
    } catch (e) {
      print('Quiz Generation Error: $e');
      // Rethrow to allow the UI to show a "Retry" button instead of silent failure
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
      final decoded = jsonDecode(_extractJson(raw)) as Map<String, dynamic>;
      return GrammarFeedback.fromJson(decoded);
    } catch (_) {
      return GrammarFeedback(correct: true, errors: [], corrected: sentence, explanation: '');
    }
  }

  // ─── PRIVATE NETWORK HELPERS ──────────────────────────────────────────────

  Future<String> _callBackendProxy(String path, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post('${AppConstants.apiBaseUrl}$path', data: body);
      
      if (response.data is Map) {
        return jsonEncode(response.data);
      }
      return response.data.toString();
    } on DioException catch (e) {
      print('Backend Proxy Error ($path): ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('We are currently unable to connect you. Please try again later.');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    } catch (e) {
      throw Exception('We are currently unable to connect you.');
    }
  }

  // ─── UTILITIES ───────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _constructChatMessages(
    List<ChatMessage> history,
    String userMessage,
    String level,
    String topic,
    String language,
  ) {
    return [
      {'role': 'system', 'content': _Prompts.tutorSystem(level, topic, language)},
      ...history.map((m) => {
            'role': m.role == MessageRole.user ? 'user' : 'assistant',
            'content': m.content,
          }),
      {'role': 'user', 'content': userMessage},
    ];
  }

  String _extractJson(String input) {
    final start = input.indexOf('{');
    final end = input.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return input.substring(start, end + 1);
    }
    return input.replaceAll('```json', '').replaceAll('```', '').trim();
  }

  LessonContent _generateFallbackLesson(String topic) {
    return LessonContent(
      title: topic.replaceAll('-', ' ').toUpperCase(),
      explanation: [
        LessonSegment(
          targetText: 'Error loading lesson.',
          english: 'Sorry, unable to load lesson. Please check your connection.',
        )
      ],
      examples: [],
      practiceQuestions: [],
    );
  }
}

/// Centralized prompts for the AI models. 
/// In a strictly production environment, these strings should reside on the backend.
class _Prompts {
  static String tutorSystem(String level, String topic, String language) =>
      "You are an expert $language tutor for level $level. Topic: $topic. "
      "Respond in ≤120 words. Show corrections in [brackets]. End with a follow-up question.";

  static String lesson(String topic, String level, String language) =>
      "Create a professional CEFR $level $language lesson on: $topic.\n\n"
      "Requirements:\n"
      "- Break the explanation into 2-3 logical segments (Introduction, Rules, Usage).\n"
      "- Each segment MUST HAVE ONLY 'targetText' (for $language) and 'english' keys.\n"
      "- Provide 3 examples and 3-5 multiple-choice questions.\n\n"
      "Return ONLY a valid JSON object with this exact structure:\n"
      "{\n"
      "  \"title\": \"...\",\n"
      "  \"explanation\": [\n"
      "    {\"targetText\": \"...\", \"english\": \"...\"}\n"
      "  ],\n"
      "  \"examples\": [\n"
      "    {\"targetText\": \"...\", \"english\": \"...\", \"note\": \"...\"}\n"
      "  ],\n"
      "  \"practiceQuestions\": [\n"
      "    {\"question\": \"...\", \"options\": [\"...\", \"...\", \"...\"], \"correctIndex\": 0, \"explanation\": \"...\"}\n"
      "  ]\n"
      "}";

  static String quiz(String topic, String level, int count, String language) =>
      "Generate $count multiple-choice $language grammar questions for CEFR level $level. Topic: $topic. "
      "Return ONLY a valid JSON object: {\"questions\":[{\"id\":\"1\",\"question\":\"...\",\"options\":[\"a\",\"b\",\"c\",\"d\"],\"correctIndex\":0,\"explanation\":\"...\",\"topic\":\"$topic\",\"level\":\"$level\"}]}";

  static String exam(String topic, String level, int count, String language) =>
      "Generate a professional $count-question Mock Test based on official $topic standards for level $level in $language. "
      "Ensure questions mimic official formats. Focus on: Advanced Grammar, Formal Contexts, and Nuanced Vocabulary. "
      "Return ONLY a valid JSON object: {\"questions\":[{\"id\":\"1\",\"question\":\"...\",\"options\":[\"a\",\"b\",\"c\",\"d\"],\"correctIndex\":0,\"explanation\":\"...\",\"topic\":\"$topic\",\"level\":\"$level\"}]}";

  static String grammar(String sentence, String language) =>
      "Check this $language sentence for grammar errors: \"$sentence\"\n"
      "Return ONLY valid JSON: {\"correct\":true,\"errors\":[],\"corrected\":\"$sentence\",\"explanation\":\"\"}";

  static String clarify(String topic, String level, String currentExplanation, String language) =>
      "The student is learning about \"$topic\" at CEFR level $level in $language.\n"
      "They read this explanation: \"$currentExplanation\"\n"
      "Provide a deeper, more detailed explanation (max 250 words) with analogies and 2 new examples.\n\n"
      "Return ONLY a valid JSON object:\n"
      "{\n"
      "  \"deeperExplanation\": \"...\",\n"
      "  \"newExamples\": [\n"
      "    {\"targetText\": \"...\", \"english\": \"...\", \"note\": \"...\"}\n"
      "  ]\n"
      "}";
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
