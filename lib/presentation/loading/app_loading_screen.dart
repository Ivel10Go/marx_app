import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class AppLoadingScreen extends StatefulWidget {
  const AppLoadingScreen({
    super.key,
    this.title = 'Zitatatlas lädt',
    this.subtitle = 'Inhalte werden vorbereitet …',
  });

  final String title;
  final String subtitle;

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
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final angle =
                      math.sin(_controller.value * math.pi * 2) * 0.08;
                  return Transform.rotate(angle: angle, child: child);
                },
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.red.withValues(alpha: 0.28),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  color: AppColors.inkLight,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final value = 0.2 + (0.8 * _controller.value);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: value,
                      backgroundColor: AppColors.rule,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.red,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
