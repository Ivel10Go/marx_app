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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'WIE SOLL AUSGEWÄHLT WERDEN?',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Entweder automatisch nach Interessen oder manuell nach Autorinnen und Autoren.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
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
                subtitle: 'Wähle Personen, von denen du Zitate sehen willst.',
                onTap: () => onModeChanged(QuoteDiscoverySelection.manual),
              ),
              const SizedBox(height: 18),
              Text(
                'AUTOREN / THEMATISCHE QUELLEN',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: availableSources.isEmpty
                    ? Center(
                        child: Text(
                          'Noch keine Quellen verfügbar.',
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
                            color: isSelected
                                ? scheme.onSurface
                                : scheme.surface,
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
                                        ? scheme.onSurface
                                        : scheme.outline,
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
                                              ? scheme.surface
                                              : scheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      size: 18,
                                      color: isSelected
                                          ? scheme.primary
                                          : scheme.onSurfaceVariant,
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
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: active ? scheme.onSurface : scheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(
              color: active ? scheme.onSurface : scheme.outline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: active ? scheme.surface : scheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: active
                      ? scheme.surface.withValues(alpha: 0.8)
                      : scheme.onSurfaceVariant,
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
