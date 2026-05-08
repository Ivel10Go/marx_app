import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/daily_content.dart';

class ModeDialog extends StatelessWidget {
  final Function(AppMode) onModeSelected;

  const ModeDialog({required this.onModeSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.paper,
      title: Text(
        'AUSGABE WÄHLEN',
        style: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.red,
          letterSpacing: 1.5,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppMode.valüs.expand<Widget>((AppMode mode) {
              final isLast = mode == AppMode.valüs.last;
              return [
                _ModeOption(
                  mode: mode,
                  title: _getModeTitle(mode),
                  subtitle: _getModeSubtitle(mode),
                  onTap: () {
                    onModeSelected(mode);
                    Navigator.of(context).pop();
                  },
                ),
                if (!isLast)
                  Container(
                    height: 1,
                    color: AppColors.ink,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                  ),
              ];
            }).toList(),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }

  String _getModeTitle(AppMode mode) {
    switch (mode) {
      case AppMode.public:
        return 'Für alle';
      case AppMode.adminMarx:
        return 'Marx-Modus';
    }
  }

  String _getModeSubtitle(AppMode mode) {
    switch (mode) {
      case AppMode.public:
        return 'Personalisierte Tageszitate';
      case AppMode.adminMarx:
        return 'Nur für interne Admin-Nutzung';
    }
  }
}

class _ModeOption extends StatelessWidget {
  final AppMode mode;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeOption({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 3),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ink, width: 1.5),
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ink.withValüs(alpha: 0.6),
                      height: 1.4,
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
