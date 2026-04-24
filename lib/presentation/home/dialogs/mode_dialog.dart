import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/godmode_colors.dart';
import '../../../data/models/daily_content.dart';

class ModeDialog extends StatelessWidget {
  final Function(AppMode) onModeSelected;
  final AppMode currentMode;

  const ModeDialog({
    required this.onModeSelected,
    required this.currentMode,
    super.key,
  });

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
            children: AppMode.values.expand<Widget>((AppMode mode) {
              final isLast = mode == AppMode.values.last;
              return <Widget>[
                _ModeOption(
                  mode: mode,
                  selected: mode == currentMode,
                  title: _getModeTitle(mode),
                  subtitle: _getModeSubtitle(mode),
                  icon: _getModeIcon(mode),
                  onTap: () {
                    onModeSelected(mode);
                    Navigator.of(context).pop();
                  },
                ),
                if (!isLast)
                  Container(
                    height: 1,
                    color: AppColors.rule,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                  ),
              ];
            }).toList(),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }

  String _getModeTitle(AppMode mode) {
    switch (mode) {
      case AppMode.marx:
        return 'Marx & Engels';
      case AppMode.history:
        return 'Weltgeschichte';
      case AppMode.mixed:
        return 'Gemischt';
      case AppMode.godmode:
        return '☭ MARX GODMODE';
    }
  }

  String _getModeSubtitle(AppMode mode) {
    switch (mode) {
      case AppMode.marx:
        return 'Zitate aus den Originalwerken';
      case AppMode.history:
        return 'Kuratierte Fakten & Ereignisse';
      case AppMode.mixed:
        return 'Täglich abwechselnd: Marx · Geschichte · Denker';
      case AppMode.godmode:
        return 'Maximale Intensität – nur die härtesten Zitate';
    }
  }

  IconData _getModeIcon(AppMode mode) {
    switch (mode) {
      case AppMode.marx:
        return Icons.menu_book_outlined;
      case AppMode.history:
        return Icons.history_edu_outlined;
      case AppMode.mixed:
        return Icons.shuffle_rounded;
      case AppMode.godmode:
        return Icons.bolt_rounded;
    }
  }
}

class _ModeOption extends StatelessWidget {
  final AppMode mode;
  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ModeOption({
    required this.mode,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGodmode = mode == AppMode.godmode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: isGodmode && selected
            ? BoxDecoration(
                color: GodmodeColors.background,
                border: Border.all(
                  color: GodmodeColors.accent.withValues(alpha: 0.6),
                ),
              )
            : null,
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
                  border: Border.all(
                    color: isGodmode
                        ? GodmodeColors.accent
                        : AppColors.ink,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isGodmode
                                ? GodmodeColors.accent
                                : AppColors.red,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Icon(
              icon,
              size: 16,
              color: isGodmode
                  ? GodmodeColors.accent
                  : AppColors.inkMuted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: isGodmode
                          ? GodmodeColors.accent
                          : AppColors.ink,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isGodmode
                          ? GodmodeColors.textMuted
                          : AppColors.ink.withValues(alpha: 0.6),
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
