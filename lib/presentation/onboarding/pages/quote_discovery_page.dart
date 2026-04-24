import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class QuoteDiscoveryPage extends StatelessWidget {
  const QuoteDiscoveryPage({
    required this.mode,
    required this.sources,
    required this.availableSources,
    required this.onModeChanged,
    required this.onToggleSource,
    super.key,
  });

  final QuoteDiscoverySelection mode;
  final Set<String> sources;
  final List<String> availableSources;
  final ValueChanged<QuoteDiscoverySelection> onModeChanged;
  final ValueChanged<String> onToggleSource;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.paper,
          border: Border(
            left: BorderSide(color: AppColors.ink, width: 1),
            right: BorderSide(color: AppColors.ink, width: 1),
            bottom: BorderSide(color: AppColors.ink, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'WIE SOLL AUSGEWAEHLT WERDEN?',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.red,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Entweder automatisch nach Interessen oder manuell nach Autorinnen und Autoren.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppColors.inkLight,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _ModeChoiceTile(
                active: mode == QuoteDiscoverySelection.interests,
                title: 'Nach Interessen',
                subtitle: 'Zitate werden passend zu deinem Profil priorisiert.',
                onTap: () => onModeChanged(QuoteDiscoverySelection.interests),
              ),
              const SizedBox(height: 10),
              _ModeChoiceTile(
                active: mode == QuoteDiscoverySelection.manual,
                title: 'Manuelle Auswahl',
                subtitle: 'Waehle Personen, von denen du Zitate sehen willst.',
                onTap: () => onModeChanged(QuoteDiscoverySelection.manual),
              ),
              const SizedBox(height: 18),
              Text(
                'AUTOREN / THEMATISCHE QUELLEN',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: availableSources.isEmpty
                    ? Center(
                        child: Text(
                          'Noch keine Quellen verfuegbar.',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            color: AppColors.inkLight,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: availableSources.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final source = availableSources[index];
                          final isSelected = sources.contains(source);
                          return Material(
                            color: isSelected ? AppColors.ink : AppColors.paper,
                            child: InkWell(
                              onTap: () => onToggleSource(source),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.ink
                                        : AppColors.rule,
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        source,
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? AppColors.paper
                                              : AppColors.ink,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      size: 18,
                                      color: isSelected
                                          ? AppColors.redOnRed
                                          : AppColors.inkMuted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum QuoteDiscoverySelection { interests, manual }

class _ModeChoiceTile extends StatelessWidget {
  const _ModeChoiceTile({
    required this.active,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool active;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.ink : AppColors.paper,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: active ? AppColors.ink : AppColors.rule),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.paper : AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: active
                      ? AppColors.paper.withValues(alpha: 0.8)
                      : AppColors.inkLight,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
