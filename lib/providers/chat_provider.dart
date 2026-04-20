import 'package:lingokaksha/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../data/models/chat_message.dart';
import '../data/repositories/chat_repository.dart';
import '../data/services/api_service.dart';

part 'chat_provider.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  late final ChatRepository _repository;
  final String _sessionId = 'default_chat'; // In future, this can be topic-specific

  @override
  List<ChatMessage> build() {
    _repository = ChatRepository();
    final language = ref.watch(selectedLanguageProvider);
    
    // Load existing history from Hive
    final savedMessages = _repository.getMessages(_sessionId);
    
    if (savedMessages.isEmpty) {
      String welcomeText = 'Hallo! Ich bin GermanShikshak, dein KI-Deutschlehrer 🇩🇪';
      if (language == 'french') {
        welcomeText = 'Bonjour! Je suis FrenchShikshak, votre tuteur de français IA 🇫🇷';
      } else if (language == 'spanish') {
        welcomeText = '¡Hola! Soy SpanishShikshak, tu tutor de español IA 🇪🇸';
      }

      return [
        ChatMessage(
          id: 'welcome-msg',
          role: MessageRole.assistant,
          content: '$welcomeText\n\nWas möchtest du heute üben?',
          timestamp: DateTime.now(),
        ),
      ];
    }
    return savedMessages;
  }

  String _currentTopic = 'general conversation';
  String _userLevel = 'A2';
  final _uuid = const Uuid();

  void setContext({required String topic, required String level}) {
    _currentTopic = topic;
    _userLevel = level;
  }

  Future<void> sendMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    // 1️⃣ Add User Message
    final userMsg = ChatMessage.user(trimmedText);
    state = [...state, userMsg];
    await _repository.saveMessages(_sessionId, state);

    // 2️⃣ Add Loading Assistant Message
    final loadingMsg = ChatMessage.loading();
    final assistantId = loadingMsg.id;
    state = [...state, loadingMsg];

    try {
      // 3️⃣ Build history for backend
      final history = state
          .where((m) => m.id != assistantId && m.role != MessageRole.system)
          .toList();

      final messages = history.map((m) => {
            "role": m.role == MessageRole.user ? "user" : "assistant",
            "content": m.content,
          }).toList();

      String accumulatedResponse = "";

      // 4️⃣ Call Streaming API
      final language = ref.read(selectedLanguageProvider);
      final stream = ApiService.streamMessage(
        messages: messages,
        level: _userLevel,
        topic: _currentTopic,
        language: language,
      );

      // 5️⃣ Stream chunks → update UI
      await for (final chunk in stream) {
        accumulatedResponse += chunk;

        state = [
          for (final m in state)
            if (m.id == assistantId)
              m.copyWith(
                content: accumulatedResponse,
                isLoading: true, // Keep loading while streaming
              )
            else
              m,
        ];
      }

      // Mark final state as not loading
      state = [
        for (final m in state)
          if (m.id == assistantId)
            m.copyWith(isLoading: false)
          else if (m.id == userMsg.id)
            m.copyWith(status: MessageStatus.sent)
          else
            m,
      ];

      // 6️⃣ Trim history & Persist
      _trimHistory();
      await _repository.saveMessages(_sessionId, state);
      
      // Update progress (example logic: increment progress slightly per exchange)
      final currentProgress = _repository.getProgress(_sessionId);
      if (currentProgress < 1.0) {
        await _repository.updateProgress(_sessionId, (currentProgress + 0.05).clamp(0.0, 1.0));
      }
      
    } catch (e) {
      // 7️⃣ Error handling
      state = [
        for (final m in state)
          if (m.id == assistantId)
            m.copyWith(
              content: 'Entschuldigung! I had trouble connecting. Please try again. 🔄',
              isLoading: false,
            )
          else if (m.id == userMsg.id)
            m.copyWith(status: MessageStatus.error)
          else
            m,
      ];
    }
  }

  void _trimHistory() {
    if (state.length > AppConstants.maxChatHistory + 1) {
      final welcome = state.first;
      final recent =
          state.sublist(state.length - AppConstants.maxChatHistory);
      state = [welcome, ...recent];
    }
  }

  void clearHistory() {
    state = [state.first];
    _repository.clearHistory(_sessionId);
  }
}
