import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizTimerNotifier extends StateNotifier<int> {
  QuizTimerNotifier() : super(15);

  Timer? _timer;

  void start({required VoidCallback onDone}) {
    _timer?.cancel();
    state = 15;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (state <= 1) {
        timer.cancel();
        state = 0;
        onDone();
      } else {
        state = state - 1;
      }
    });
  }

  void reset() {
    _timer?.cancel();
    state = 15;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final quizTimerProvider = StateNotifierProvider<QuizTimerNotifier, int>(
  (Ref ref) => QuizTimerNotifier(),
);
