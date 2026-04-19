import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/tts_provider.dart';

class TtsButton extends ConsumerWidget {
  const TtsButton({
    required this.contentId,
    required this.text,
    this.size = 20,
    super.key,
  });

  final String contentId;
  final String text;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsStateProvider);
    final isPlaying = ttsState == contentId;

    return GestureDetector(
      onTap: () => ref.read(ttsStateProvider.notifier).toggle(contentId, text),
      child: Icon(
        isPlaying ? Icons.stop_rounded : Icons.volume_up_outlined,
        size: size,
        color: isPlaying ? AppColors.red : AppColors.inkLight,
      ),
    );
  }
}
