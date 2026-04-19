import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/quote.dart';
import '../services/tts_service.dart';

final ttsServiceProvider = Provider<TtsService>((Ref ref) {
  final service = TtsService();
  service.init();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

class TtsStateNotifier extends StateNotifier<String?> {
  TtsStateNotifier(this._ref) : super(null) {
    final svc = _ref.read(ttsServiceProvider);
    svc.onPlaybackCompleted = () async {
      state = null;
    };
  }

  final Ref _ref;

  Future<void> toggle(String contentId, String text) async {
    final svc = _ref.read(ttsServiceProvider);

    if (state == contentId) {
      await svc.stop();
      state = null;
      return;
    }

    state = contentId;
    await svc.speak(text);
  }

  Future<void> toggleQuote(String contentId, Quote quote) async {
    final svc = _ref.read(ttsServiceProvider);

    if (state == contentId) {
      await svc.stop();
      state = null;
      return;
    }

    state = contentId;
    await svc.speakQuote(quote);
  }
}

final ttsStateProvider = StateNotifierProvider<TtsStateNotifier, String?>(
  (Ref ref) => TtsStateNotifier(ref),
);
