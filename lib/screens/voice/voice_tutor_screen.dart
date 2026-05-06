import 'package:flutter/services.dart'; // Added for Haptics
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../data/services/gpt_service.dart';

class VoiceTutorScreen extends ConsumerStatefulWidget {
  const VoiceTutorScreen({super.key});

  @override
  ConsumerState<VoiceTutorScreen> createState() => _VoiceTutorScreenState();
}

class _VoiceTutorScreenState extends ConsumerState<VoiceTutorScreen> {
  final _recorder = AudioRecorder();
  final _tts = FlutterTts();
  
  // State Management
  bool _isSessionActive = false;
  bool _isRecording = false;
  bool _isProcessing = false;
  
  String? _audioPath;
  double _speechRate = 0.5;
  double _currentAmplitude = -160.0;
  
  final List<Map<String, String>> _history = [];
  Map<String, dynamic>? _lastAnalysis;
  String _status = "Select a mode and tap Start";
  String _selectedMode = 'free_flow';

  final List<Map<String, String>> _modes = [
    {'id': 'free_flow', 'title': 'Free Flow', 'icon': '🗨️', 'mission': 'Talk about anything on your mind!'},
    {'id': 'doctor', 'title': 'Doctor Appt.', 'icon': '🏥', 'mission': 'Describe your symptoms and ask for a prescription.'},
    {'id': 'restaurant', 'title': 'Restaurant', 'icon': '🍽️', 'mission': 'Order a 3-course meal and ask for the bill.'},
    {'id': 'job', 'title': 'Job Interview', 'icon': '💼', 'mission': 'Explain your experience and ask about the salary.'},
  ];

  StreamSubscription<Amplitude>? _amplitudeSub;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _tts.setLanguage("de-DE");
    await _tts.setSpeechRate(_speechRate);
    _tts.setCompletionHandler(() {
      setState(() => _status = "Tap Mic to reply");
    });
  }

  void _updateSpeechRate(double rate) async {
    setState(() => _speechRate = rate);
    await _tts.setSpeechRate(rate);
  }

  @override
  void dispose() {
    _amplitudeSub?.cancel();
    _recorder.dispose();
    _tts.stop();
    super.dispose();
  }

  /// Main Button Logic: Toggle Session -> Toggle Mic
  Future<void> _handleMicTap() async {
    if (!_isSessionActive) {
      await _startSession();
      return;
    }

    if (_isRecording) {
      await _stopAndProcess();
    } else if (!_isProcessing) {
      await _startRecording();
    }
  }

  Future<void> _startSession() async {
    setState(() {
      _isSessionActive = true;
      _status = "Initializing AI...";
      _history.clear();
      _lastAnalysis = null;
    });
    await _initiateConversation();
  }

  Future<void> _initiateConversation() async {
    try {
      final level = ref.read(selectedLevelProvider) ?? 'A1';
      final language = ref.read(selectedLanguageProvider);
      
      final response = await ref.read(gptServiceProvider).startVoiceSession(
        mode: _selectedMode,
        language: language,
        level: level,
      );

      _history.add({"role": "assistant", "content": response});
      setState(() => _status = "AI is speaking...");
      await _tts.speak(response);
    } catch (e) {
      setState(() {
        _status = "Tap Mic to start";
        _isSessionActive = false;
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final voiceDir = Directory('${directory.path}/recordings');
        if (!await voiceDir.exists()) await voiceDir.create(recursive: true);

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        _audioPath = '${voiceDir.path}/voice_$timestamp.m4a';
        
        await _recorder.start(const RecordConfig(), path: _audioPath!);
        HapticFeedback.lightImpact();

        setState(() {
          _isRecording = true;
          _status = "Listening... Tap to stop";
        });

        _amplitudeSub = _recorder.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((amp) {
          setState(() => _currentAmplitude = amp.current);
        });
      }
    } catch (e) {
      debugPrint("Recording Error: $e");
    }
  }

  Future<void> _stopAndProcess() async {
    _amplitudeSub?.cancel();
    HapticFeedback.mediumImpact();

    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _isProcessing = true;
      _status = "AI is thinking...";
      _currentAmplitude = -160.0;
    });

    if (path != null) {
      _cleanupOldRecordings();
      _processAudio(path);
    }
  }

  Future<void> _processAudio(String path) async {
    try {
      final level = ref.read(selectedLevelProvider) ?? 'A1';
      final language = ref.read(selectedLanguageProvider);

      final result = await ref.read(gptServiceProvider).analyzeVoice(
        audioPath: path,
        language: language,
        level: level,
        mode: _selectedMode,
        history: _history,
      );

      final userText = result['user_text'] ?? "";
      final aiResponse = result['tutor_response'] ?? "";

      if (userText.isNotEmpty) _history.add({"role": "user", "content": userText});
      if (aiResponse.isNotEmpty) _history.add({"role": "assistant", "content": aiResponse});

      setState(() {
        _lastAnalysis = result;
        _isProcessing = false;
      });

      if (aiResponse.isNotEmpty && _isSessionActive) {
        setState(() => _status = "AI is speaking...");
        await _tts.speak(aiResponse);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _status = "Error. Tap Mic to try again.";
      });
    }
  }

  void _endSession() {
    _tts.stop();
    _recorder.stop();
    _amplitudeSub?.cancel();
    setState(() {
      _isSessionActive = false;
      _isRecording = false;
      _isProcessing = false;
      _status = "Session ended";
    });
  }

  /// Professional-grade rotation: Keeps only the last 15 recordings to save space.
  Future<void> _cleanupOldRecordings() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final voiceDir = Directory('${directory.path}/recordings');
      if (!await voiceDir.exists()) return;

      final files = voiceDir.listSync().whereType<File>().toList();
      
      // Sort by creation time (oldest first)
      files.sort((a, b) => a.statSync().changed.compareTo(b.statSync().changed));

      if (files.length > 15) {
        final toDelete = files.take(files.length - 15);
        for (var file in toDelete) {
          await file.delete();
          debugPrint("Cleaned up old recording: ${file.path}");
        }
      }
    } catch (e) {
      debugPrint("Cleanup Error: $e");
    }
  }

  Widget _speedBtn(String label, double rate, bool active, bool isDark) {
    return GestureDetector(
      onTap: () => _updateSpeechRate(rate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: active ? Colors.deepPurple : (isDark ? AppColors.surfaceVariantDark : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? Colors.deepPurple : (isDark ? AppColors.dividerDark : Colors.grey.shade300)
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : (isDark ? AppColors.textHintDark : Colors.grey),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: const Text("AI Voice Tutor"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        actions: [
          if (_isSessionActive)
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.red),
              onPressed: _endSession,
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Mode Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _modes.map((mode) {
                  final isSelected = _selectedMode == mode['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text("${mode['icon']} ${mode['title']}"),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val && !_isRecording && !_isProcessing) {
                          setState(() {
                            _selectedMode = mode['id']!;
                            _history.clear();
                            _lastAnalysis = null;
                            _status = "Tap Mic to start ${mode['title']}";
                          });
                        }
                      },
                      selectedColor: Colors.deepPurple.withValues(alpha: 0.2),
                      backgroundColor: isDark ? AppColors.surfaceVariantDark : Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.deepPurple : (isDark ? AppColors.textSecondaryDark : Colors.grey),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            
            // Mission Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _modes.firstWhere((m) => m['id'] == _selectedMode)['mission']!,
                      style: TextStyle(
                        fontSize: 13, 
                        fontWeight: FontWeight.w600, 
                        color: isDark ? Colors.orangeAccent : Colors.orange.shade800
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

            const SizedBox(height: 30),
            
            // Speed Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AI Speed: ", 
                  style: TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.bold, 
                    color: isDark ? AppColors.textHintDark : Colors.grey
                  )
                ),
                _speedBtn("Slow", 0.4, _speechRate == 0.4, isDark),
                const SizedBox(width: 8),
                _speedBtn("Normal", 0.6, _speechRate == 0.6, isDark),
              ],
            ),

            const SizedBox(height: 30),
            
            // Pulse Animation & Waveform UI
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Real-time Waveform Effect
                  if (_isRecording)
                    ...List.generate(5, (index) {
                      final normalizedAmp = (_currentAmplitude + 160).clamp(0, 160) / 160;
                      return Container(
                        width: 100 + (index * 30.0 * normalizedAmp),
                        height: 100 + (index * 30.0 * normalizedAmp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.deepPurple.withValues(alpha: 0.2 - (index * 0.04)),
                            width: 2,
                          ),
                        ),
                      );
                    }),

                  if (_isRecording)
                    ...List.generate(3, (index) => 
                      Container(
                        width: 140 + (index * 40.0),
                        height: 140 + (index * 40.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple.withValues(alpha: 0.1),
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1000.ms, curve: Curves.easeOut)
                       .fadeOut()
                    ),
                  
                  GestureDetector(
                    onTap: _handleMicTap,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : Colors.deepPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording ? Colors.red : Colors.deepPurple).withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : (_isSessionActive ? Icons.mic : Icons.play_arrow),
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
                color: _isRecording ? Colors.red : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
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
                    if (_lastAnalysis!['corrected'] != null && _lastAnalysis!['corrected'] != "" && 
                        !(_lastAnalysis!['user_text'] ?? "").startsWith(_lastAnalysis!['corrected']))
                      _FeedbackCard(
                        title: "Grammar Correction",
                        content: _lastAnalysis!['corrected'],
                        explanation: _lastAnalysis!['explanation'],
                        icon: Icons.spellcheck,
                        color: Colors.redAccent,
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
  final String? explanation;
  final IconData icon;
  final Color color;

  const _FeedbackCard({
    required this.title,
    required this.content,
    this.explanation,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.2 : 0.1)),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
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
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          if (explanation != null && explanation!.isNotEmpty) ...[
            const Divider(height: 20),
            Text(
              explanation!,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
