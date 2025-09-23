import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:leksis/secrets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TTSLanguage {
  english('en-US', 'English', 'en_US'),
  welsh('cy', 'Cymraeg', 'cy'),
  dutch('nl-NL', 'Nederlands', 'nl_NL'),
  danish('da-DK', 'Dansk', 'da_DK'),
  norwegian('nb-NO', 'Norsk (Bokmål)', 'nb_NO'),
  greek('el-GR', 'Ελληνικά', 'el_GR'),
  spanish('es-ES', 'Español', 'es_ES'),
  french('fr-FR', 'Français', 'fr_FR'),
  german('de-DE', 'Deutsch', 'de_DE'),
  italian('it-IT', 'Italiano', 'it_IT'),
  polish('pl-PL', 'Polski', 'pl-PL'),
  portuguese('pt-BR', 'Português', 'pt_BR'),
  russian('ru-RU', 'Русский', 'ru_RU'),
  turkish('tr-TR', 'Türkçe', 'tr_TR'),
  japanese('ja-JP', '日本語', 'ja_JP'),
  chinese('zh-CN', '日本語', 'zh_CN'),
  korean('ko-KR', '한국인', 'ko_KR'),
  arabic('ar', 'عربي', 'ar'),
  hindi('hi-IN', 'हिंदी"', 'hi_IN');

  final String code;
  final String name;
  final String locale;

  const TTSLanguage(this.code, this.name, this.locale);
}

class TTSService {
  // Remove singleton pattern - each folder gets its own instance
  TTSService(this.folderId);

  final String folderId; // Unique identifier for each folder
  final FlutterTts _flutterTts = FlutterTts();
  AudioPlayer? _audioPlayer;
  TTSLanguage _currentLanguage = TTSLanguage.english;
  bool _initialized = false;
  bool _disposed = false;

  bool get isDisposed => _disposed;

  Future<void> initialize() async {
    if (_initialized || _disposed) return;

    // Load language preference for this specific folder
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('tts_language_$folderId');

    if (savedLanguageCode != null) {
      final language = TTSLanguage.values.firstWhere(
        (lang) => lang.code == savedLanguageCode,
        orElse: () => TTSLanguage.english,
      );
      _currentLanguage = language;
    } else {
      // If no folder-specific setting, use global default
      final globalLanguageCode = prefs.getString('tts_language_global');
      if (globalLanguageCode != null) {
        final language = TTSLanguage.values.firstWhere(
          (lang) => lang.code == globalLanguageCode,
          orElse: () => TTSLanguage.english,
        );
        _currentLanguage = language;
      }
    }

    // Initialize AudioPlayer
    _audioPlayer = AudioPlayer();

    // Configure FlutterTts
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    if (_currentLanguage != TTSLanguage.welsh) {
      await _flutterTts.setLanguage(_currentLanguage.code);
    }

    _initialized = true;
  }

  Future<void> setLanguage(TTSLanguage language) async {
    if (_disposed) return;

    _currentLanguage = language;

    final prefs = await SharedPreferences.getInstance();
    // Save language preference for this specific folder
    await prefs.setString('tts_language_$folderId', language.code);

    if (language != TTSLanguage.welsh) {
      await _flutterTts.setLanguage(language.code);
    }
  }

  TTSLanguage get currentLanguage => _currentLanguage;

  List<TTSLanguage> get availableLanguages => TTSLanguage.values;

  Future<void> speak(String text) async {
    if (text.isEmpty || _disposed) return;

    if (!_initialized) {
      await initialize();
    }

    if (_currentLanguage == TTSLanguage.welsh) {
      await _speakWelsh(text);
    } else {
      await _speakWithFlutterTts(text);
    }
  }

  Future<void> _speakWithFlutterTts(String text) async {
    try {
      if (_disposed) return;
      await _flutterTts.speak(text);
    } catch (e) {
      _initialized = false;
      await initialize();
    }
  }

  Future<void> _speakWelsh(String text) async {
    try {
      if (_disposed || _audioPlayer == null) return;

      const apiKey = Secrets.apiKey;

      final url = Uri.parse(
        "https://api.techiaith.org/marytts/v1/"
        "?api_key=$apiKey"
        "&uid=benyw-gogledd"
        "&text=${Uri.encodeComponent(text)}",
      );

      final response = await http.get(url);

      if (response.statusCode == 200 && !_disposed) {
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/welsh_tts_${DateTime.now().millisecondsSinceEpoch}.wav',
        );
        await file.writeAsBytes(response.bodyBytes);

        await _audioPlayer!.stop();
        await _audioPlayer!.play(DeviceFileSource(file.path));
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (!_disposed) {
        await _flutterTts.setLanguage('cy');
        await _flutterTts.speak(text);
      }
    }
  }

  Future<void> stop() async {
    if (_disposed) return;

    await _flutterTts.stop();
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
  }

  void dispose() {
    if (_disposed) return;

    _disposed = true;
    _flutterTts.stop();

    if (_audioPlayer != null) {
      _audioPlayer!.dispose();
      _audioPlayer = null;
    }
  }
}
