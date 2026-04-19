import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.optionIndex,
    required this.label,
    required this.onTap,
    required this.isLocked,
    required this.isCorrect,
    required this.isSelectedWrong,
    super.key,
  });

  final int optionIndex;
  final String label;
  final VoidCallback onTap;
  final bool isLocked;
  final bool isCorrect;
  final bool isSelectedWrong;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect
        ? AppColors.saved
        : isSelectedWrong
        ? AppColors.red
        : AppColors.ink;
    final bg = isCorrect
        ? const Color(0xFFDCECE1)
        : isSelectedWrong
        ? const Color(0xFFF6DEDB)
        : AppColors.paper;
    final optionLetter = String.fromCharCode(65 + optionIndex);

    return OutlinedButton(
      onPressed: isLocked ? null : onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: bg,
        side: BorderSide(color: color, width: 1),
        foregroundColor: color,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
            ),
            child: Text(
              optionLetter,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          if (isCorrect)
            const Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: AppColors.saved,
            ),
          if (isSelectedWrong)
            const Icon(Icons.cancel_rounded, size: 18, color: AppColors.red),
        ],
      ),
    );
  }
}
