import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/session_provider.dart';
import '../../data/services/gpt_service.dart';

class VoiceTutorScreen extends ConsumerStatefulWidget {
  const VoiceTutorScreen({super.key});

  @override
  ConsumerState<VoiceTutorScreen> createState() => _VoiceTutorScreenState();
}

class _VoiceTutorScreenState extends ConsumerState<VoiceTutorScreen> {
  final _recorder = AudioRecorder();
  final _tts = FlutterTts();
  
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _audioPath;
  
  Map<String, dynamic>? _lastAnalysis;
  String _status = "Tap to start speaking";

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _tts.setLanguage("de-DE");
    await _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _recorder.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        _audioPath = '${directory.path}/voice_temp.m4a';
        
        await _recorder.start(const RecordConfig(), path: _audioPath!);
        setState(() {
          _isRecording = true;
          _status = "Listening...";
        });
      }
    } catch (e) {
      debugPrint("Recording Error: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
        _status = "Analyzing your speech...";
      });

      if (path != null) {
        final level = ref.read(selectedLevelProvider) ?? 'A1';
        final language = ref.read(selectedLanguageProvider);

        final result = await ref.read(gptServiceProvider).analyzeVoice(
          audioPath: path,
          language: language,
          level: level,
          mode: 'roleplay',
        );

        setState(() {
          _lastAnalysis = result;
          _isProcessing = false;
          _status = "Tap to speak again";
        });

        if (result['tutor_response'] != null) {
          await _tts.speak(result['tutor_response']);
        }
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _status = "Service temporarily unavailable. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("AI Voice Tutor"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Pulse Animation UI
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isRecording)
                    ...List.generate(3, (index) => 
                      Container(
                        width: 140 + (index * 40.0),
                        height: 140 + (index * 40.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple.withOpacity(0.1),
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1000.ms, curve: Curves.easeOut)
                       .fadeOut(begin: 1.0, end: 0.0)
                    ),
                  
                  GestureDetector(
                    onTapDown: (_) => _startRecording(),
                    onTapUp: (_) => _stopRecording(),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : Colors.deepPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording ? Colors.red : Colors.deepPurple).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Text(
              _status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _isRecording ? Colors.red : AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 40),
            
            if (_lastAnalysis != null)
              Expanded(
                child: ListView(
                  children: [
                    _FeedbackCard(
                      title: "What you said",
                      content: _lastAnalysis!['user_text'] ?? "...",
                      icon: Icons.chat_bubble_outline,
                      color: AppColors.primary,
                    ),
                    _FeedbackCard(
                      title: "AI Response",
                      content: _lastAnalysis!['tutor_response'] ?? "...",
                      icon: Icons.android,
                      color: Colors.deepPurple,
                    ),
                    _FeedbackCard(
                      title: "Pronunciation Score",
                      content: "${_lastAnalysis!['pronunciation_score']}%",
                      icon: Icons.star_outline,
                      color: Colors.orange,
                    ),
                    if (_lastAnalysis!['vocab_upgrades'] != null)
                      _FeedbackCard(
                        title: "Vocabulary Level-up",
                        content: (_lastAnalysis!['vocab_upgrades'] as List).join(", "),
                        icon: Icons.trending_up,
                        color: Colors.green,
                      ),
                  ],
                ),
              ),
            
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _FeedbackCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
