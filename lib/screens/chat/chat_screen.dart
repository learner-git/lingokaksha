import 'package:lingokaksha/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/chat_message.dart';
import '../../data/services/gpt_service.dart';
import '../../providers/chat_provider.dart';
import '../../providers/session_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isCheckingGrammar = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkGrammar() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _isCheckingGrammar = true);

    try {
      final language = ref.read(selectedLanguageProvider).toLowerCase().trim();
      final feedback = await ref.read(gptServiceProvider).checkGrammar(text, language);
      if (!mounted) return;

      if (feedback.correct) {
        final successMsg = language == 'german' 
            ? 'Perfect! Your German is correct. ✅' 
            : language == 'french' 
                ? 'Parfait! Votre français est correct. ✅' 
                : '¡Perfecto! Tu español es correcto. ✅';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMsg),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _showGrammarFeedback(feedback);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oops! This service is temporarily unavailable. Please try again later.')),
      );
    } finally {
      if (mounted) setState(() => _isCheckingGrammar = false);
    }
  }

  void _showGrammarFeedback(GrammarFeedback feedback) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('📝 Grammar Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Your sentence:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            Text(_inputCtrl.text, style: const TextStyle(fontSize: 15, decoration: TextDecoration.lineThrough, color: AppColors.error)),
            const SizedBox(height: 12),
            const Text('Corrected version:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Text(feedback.corrected, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.success)),
            ),
            if (feedback.explanation.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Explanation:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              Text(feedback.explanation, style: const TextStyle(fontSize: 14)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _inputCtrl.text = feedback.corrected;
                  Navigator.pop(context);
                },
                child: const Text('Apply Correction'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    // Check if we are already waiting for a response
    final messages = ref.read(chatNotifierProvider);
    if (messages.isNotEmpty && messages.last.isLoading) return;

    _inputCtrl.clear();

    // ⚡ Logic is handled in the notifier (Streaming)
    ref.read(chatNotifierProvider.notifier).sendMessage(text);
    ref.read(sessionNotifierProvider.notifier).recordChatMessage();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showScenarios() {
    final language = ref.read(selectedLanguageProvider);
    final scenarios = language == 'german' 
        ? [
            {'icon': '☕', 'title': 'Im Café', 'desc': 'Bestelle einen Kaffee und Kuchen.'},
            {'icon': '🏨', 'title': 'Im Hotel', 'desc': 'Checke in ein Hotelzimmer ein.'},
            {'icon': '👨‍⚕️', 'title': 'Beim Arzt', 'desc': 'Erkläre deine Symptome.'},
          ]
        : language == 'french'
            ? [
                {'icon': '☕', 'title': 'Au café', 'desc': 'Commandez un café et un croissant.'},
                {'icon': '🏨', 'title': 'À l\'hôtel', 'desc': 'Enregistrez-vous à l\'hôtel.'},
                {'icon': '👨‍⚕️', 'title': 'Chez le médecin', 'desc': 'Expliquez vos symptômes.'},
              ]
            : [
                {'icon': '☕', 'title': 'En el café', 'desc': 'Pide un café y un postre.'},
                {'icon': '🏨', 'title': 'En el hotel', 'desc': 'Haz el check-in en el hotel.'},
                {'icon': '👨‍⚕️', 'title': 'En el médico', 'desc': 'Explica tus síntomas.'},
              ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Roleplay Scenario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            const SizedBox(height: 16),
            ...scenarios.map((s) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(s['icon']!),
              ),
              title: Text(s['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(s['desc']!),
              onTap: () {
                Navigator.pop(context);
                final prompt = language == 'german' 
                  ? 'Lass uns ein Rollenspiel machen: ${s['title']}. Ich bin der Kunde/Patient und du bist der Angestellte/Arzt. Fang an.'
                  : language == 'french'
                    ? 'Jouons un jeu de rôle : ${s['title']}. Je suis le client/patient et tu es l\'employé/médecin. Commence.'
                    : 'Hagamos un juego de rol: ${s['title']}. Soy el cliente/paciente y tú eres el empleado/médico. Empieza.';
                ref.read(chatNotifierProvider.notifier).sendMessage(prompt);
              },
            )).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatNotifierProvider);
    final language = ref.watch(selectedLanguageProvider);
    final theme = Theme.of(context);
    final isAssistantLoading = messages.isNotEmpty && messages.last.isLoading;

    final tutorName = language == 'german' 
        ? 'GermanShikshak' 
        : language == 'french' 
            ? 'FrenchShikshak' 
            : 'SpanishShikshak';
            
    final tutorTitle = language == 'german' 
        ? 'AI German Tutor • Online' 
        : language == 'french' 
            ? 'AI French Tutor • Online' 
            : 'AI Spanish Tutor • Online';

    final hintText = language == 'german' 
        ? 'Schreib auf Deutsch...' 
        : language == 'french' 
            ? 'Écrivez en français...' 
            : 'Escribe en español...';

    // 🔥 Auto-scroll when new messages / stream updates
    ref.listen(chatNotifierProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(tutorName, style: const TextStyle(fontSize: 16)),
                Text(
                  tutorTitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.secondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.theater_comedy_rounded, color: AppColors.primary),
            onPressed: _showScenarios,
            tooltip: 'Roleplay scenarios',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(chatNotifierProvider.notifier).clearHistory(),
            tooltip: 'New conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Messages ─────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];
                return _ChatBubble(message: msg)
                    .animate()
                    .fadeIn(duration: 250.ms)
                    .slideY(begin: 0.05, duration: 250.ms);
              },
            ),
          ),

          // ── Suggestions (Hidden while typing) ──────────────────────────
          if (!isAssistantLoading)
            _SuggestionChips(
              onTap: (s) {
                _inputCtrl.text = s;
                _send();
              },
            ),

          // ── Input ───────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
            ),
            child: Row(
              children: [
                // 🔥 Grammar Check Button
                if (_inputCtrl.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: _isCheckingGrammar ? null : _checkGrammar,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: _isCheckingGrammar
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.auto_fix_high_rounded, color: AppColors.secondary, size: 20),
                        ),
                      ),
                    ).animate().scale().fadeIn(),
                  ),

                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    textInputAction: TextInputAction.send,
                    onChanged: (val) => setState(() {}), // Refresh to show/hide grammar button
                    onSubmitted: (_) => _send(),
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(color: AppColors.textHint),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 🔥 Send Button
                Material(
                  color: isAssistantLoading ? AppColors.textHint : AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: isAssistantLoading ? null : _send,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: isAssistantLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser 
              ? AppColors.primary 
              : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isLoading && message.content.isEmpty)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else ...[
              Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                  fontSize: 15,
                ),
              ),
              if (message.status == MessageStatus.error)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('❌ This service is temporarily unavailable.', style: TextStyle(color: Colors.red, fontSize: 10)),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SuggestionChips extends ConsumerWidget {
  final Function(String) onTap;
  const _SuggestionChips({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(selectedLanguageProvider);
    
    final suggestions = language == 'german' 
        ? ['Wie geht es dir?', 'Erzähl mir einen Witz', 'Grammatik Hilfe']
        : language == 'french'
            ? ['Comment allez-vous ?', 'Raconte-moi une blague', 'Aide à la grammaire']
            : ['¿Cómo estás?', 'Cuéntame un chiste', 'Ayuda con la gramática'];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(suggestions[i], style: const TextStyle(fontSize: 12)),
              onPressed: () => onTap(suggestions[i]),
              backgroundColor: AppColors.surfaceVariant,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          );
        },
      ),
    );
  }
}
