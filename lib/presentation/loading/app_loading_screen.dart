import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class AppLoadingScreen extends StatefulWidget {
  const AppLoadingScreen({
    super.key,
    this.title = 'Zitatatlas lädt',
    this.subtitle = 'Inhalte werden vorbereitet …',
    this.progress,
  });

  final String title;
  final String subtitle;
  final double? progress;

  @override
  State<AppLoadingScreen> createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends State<AppLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeProgress = widget.progress == null
        ? null
        : widget.progress!.clamp(0.0, 1.0);
    final displayProgress = safeProgress == null
        ? null
        : (safeProgress == 0.0 ? 0.06 : safeProgress);
    final percentText = safeProgress == null
        ? 'Synchronisiere ...'
        : '${(safeProgress * 100).round()}%';

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'APP START',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.red,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Container(width: 44, height: 2, color: AppColors.red),
              const Spacer(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.ink, width: 1),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final angle =
                                  math.sin(_controller.value * math.pi * 2) *
                                  0.04;
                              return Transform.rotate(
                                angle: angle,
                                child: child,
                              );
                            },
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.auto_stories_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          color: AppColors.inkLight,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 12,
                          value: displayProgress,
                          backgroundColor: AppColors.rule.withValues(
                            alpha: 0.65,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          percentText,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
