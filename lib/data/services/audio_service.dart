import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_service.g.dart';

@riverpod
AudioService audioService(AudioServiceRef ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
}

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  // ── Play a URL (Firestore-stored audio or OpenAI TTS) ────────────────────

  Future<void> playUrl(String url) async {
    try {
      _isPlaying = true;
      await _player.setUrl(url);
      await _player.play();
      _isPlaying = false;
    } catch (e) {
      _isPlaying = false;
      rethrow;
    }
  }

  // ── Play a local asset ────────────────────────────────────────────────────

  Future<void> playAsset(String assetPath) async {
    try {
      _isPlaying = true;
      await _player.setAsset(assetPath);
      await _player.play();
      _isPlaying = false;
    } catch (e) {
      _isPlaying = false;
    }
  }

  // ── Stop ──────────────────────────────────────────────────────────────────

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  // ── Volume ────────────────────────────────────────────────────────────────

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  // ── Pronunciation helper ──────────────────────────────────────────────────
  // Calls your backend /api/tts which uses OpenAI TTS (free tier has no TTS,
  // so this uses the gTTS or a free alternative in dev mode)

  Future<String?> getTtsUrl(String text, {String lang = 'de'}) async {
    // In production: call your backend /api/tts?text=...&lang=de
    // Returns a pre-signed URL or a data URL
    // For development: return null (skip TTS)
    return null;
  }

  Future<void> pronounce(String text, {String? lang}) async {
    final language = lang ?? 'de';
    final url = await getTtsUrl(text, lang: language);
    if (url != null) await playUrl(url);
  }
}
