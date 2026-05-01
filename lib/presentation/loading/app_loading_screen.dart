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
    with TickerProviderStateMixin {
  late final AnimationController _floatingController;
  late final AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late Animation<double> _floatingAnimation;
  double _previousProgressValue = 0.06;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: 0,
      end: 20,
    ).animate(CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut));

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _updateProgressAnimation();
  }

  @override
  void didUpdateWidget(AppLoadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _updateProgressAnimation();
    }
  }

  void _updateProgressAnimation() {
    final targetProgress = (widget.progress?.clamp(0.0, 1.0) ?? 0.0);
    final displayProgress = targetProgress == 0.0 ? 0.06 : targetProgress;

    _progressAnimation = Tween<double>(
      begin: _previousProgressValue,
      end: displayProgress,
    ).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));

    _previousProgressValue = displayProgress;
    _progressController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeProgress = widget.progress?.clamp(0.0, 1.0);
    final percentText = safeProgress == null
        ? 'Synchronisiere ...'
        : '${(safeProgress * 100).round()}%';

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.paper,
        child: Stack(
          children: [
            // Animated background elements
            Positioned(
              top: -50,
              right: -50,
              child: AnimatedBuilder(
                animation: _floatingAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingAnimation.value),
                    child: child,
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: AnimatedBuilder(
                animation: _floatingAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_floatingAnimation.value),
                    child: child,
                  );
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Container(
                          width: 80,
                          height: 80,
                          color: AppColors.red,
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Title
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Subtitle
                        Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 14,
                            color: AppColors.inkLight,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Progress bar
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Column(
                              children: [
                                ClipRect(
                                  child: LinearProgressIndicator(
                                    minHeight: 4,
                                    value: _progressAnimation.value,
                                    backgroundColor:
                                        AppColors.rule.withValues(alpha: 0.3),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.red,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  percentText,
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.ink,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
