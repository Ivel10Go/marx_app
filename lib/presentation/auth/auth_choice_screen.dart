import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ZITATATLAS',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(width: 40, height: 2, color: AppColors.red),
              const SizedBox(height: 24),
              Text(
                'Melde dich an oder erstelle ein Konto. Das Onboarding kommt erst nach der Registrierung.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const Spacer(),
              _ActionButton(
                label: 'ANMELDEN',
                filled: true,
                onTap: () => context.go('/login'),
              ),
              const SizedBox(height: 12),
              _ActionButton(
                label: 'REGISTRIEREN',
                filled: false,
                onTap: () => context.go('/register'),
              ),
              const SizedBox(height: 12),
              Text(
                'Login und Onboarding sind getrennte Schritte.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: filled ? scheme.onSurface : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: filled ? null : Border.all(color: scheme.outline),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: filled ? scheme.surface : scheme.onSurface,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
