import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceInputService {
  static final SpeechToText _speech = SpeechToText();
  static bool _isInitialized = false;

  /// Initialize speech recognition
  static Future<bool> init() async {
    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize(
      onError: (error) {
        print('Speech recognition error: ${error.errorMsg}');
      },
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
    );
    return _isInitialized;
  }

  /// Check if speech recognition is available
  static Future<bool> isAvailable() async {
    if (!_isInitialized) {
      await init();
    }
    return _isInitialized;
  }

  /// Check if currently listening
  static bool get isListening => _speech.isListening;

  /// Start listening for speech
  static Future<void> startListening({
    required Function(String) onResult,
    String localeId = 'vi_VN',
  }) async {
    if (!_isInitialized) {
      final initialized = await init();
      if (!initialized) return;
    }

    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords);
      },
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      ),
    );
  }

  /// Stop listening
  static Future<void> stopListening() async {
    await _speech.stop();
  }

  /// Cancel listening
  static Future<void> cancelListening() async {
    await _speech.cancel();
  }

  /// Get available locales for speech recognition
  static Future<List<LocaleName>> getLocales() async {
    if (!_isInitialized) {
      await init();
    }
    return await _speech.locales();
  }

  /// Get locale ID based on language code
  static String getLocaleId(String languageCode) {
    switch (languageCode) {
      case 'vi':
        return 'vi_VN';
      case 'en':
        return 'en_US';
      case 'ja':
        return 'ja_JP';
      default:
        return 'vi_VN';
    }
  }
}
