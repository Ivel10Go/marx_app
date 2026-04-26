import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({
    required this.days,
    this.expanded = false,
    this.onTap,
    super.key,
  });

  final int days;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.red,
        border: Border.all(color: AppColors.red, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'SERIE',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.redOnRed.withValues(alpha: 0.8),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'TAG $days',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.redOnRed,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 18,
            color: AppColors.redOnRed.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 10),
          Icon(
            expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            size: 14,
            color: AppColors.redOnRed,
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.zero,
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        child: content,
      ),
    );
  }
}
