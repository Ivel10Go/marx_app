import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_decorated_scaffold.dart';

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppDecoratedScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, -0.18),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                  ),
              child: FadeTransition(
                opacity: _controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.red.withValues(alpha: 0.24),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text('📚', style: TextStyle(fontSize: 34)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Zitatatlas',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(width: 40, height: 2, color: AppColors.red),
                    const SizedBox(height: 10),
                    Text(
                      'Entdecke die Weisheit großer Denker.',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.18),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                    ),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FilledButton(
                    onPressed: () => context.go('/login'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'ANMELDEN',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => context.go('/register'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: scheme.outline, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'REGISTRIEREN',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.red,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Deine Daten werden sicher gespeichert.',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
