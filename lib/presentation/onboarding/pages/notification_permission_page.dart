import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPermissionPage extends StatelessWidget {
  const NotificationPermissionPage({
    required this.onAllow,
    required this.onSkip,
    super.key,
  });

  final Future<void> Function() onAllow;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            left: BorderSide(color: scheme.outline, width: 1),
            right: BorderSide(color: scheme.outline, width: 1),
            bottom: BorderSide(color: scheme.outline, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Lass dich täglich erinnern',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Jeden Morgen erscheint ein Satz aus der Tagesausgabe auf deinem Gerät.',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              _PrimaryButton(
                label: 'BENACHRICHTIGUNGEN ERLAUBEN',
                onTap: onAllow,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onSkip,
                child: Text(
                  'Überspringen',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.onSurface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: scheme.surface,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
