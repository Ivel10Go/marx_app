import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile.dart';
import '../../../domain/providers/quote_sources_provider.dart';
import '../../../domain/providers/user_profile_provider.dart';

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final sourcesAsync = ref.watch(availableQuoteSourcesProvider);
    final interests = availableInterests
        .where(
          (InterestOption option) =>
              profile.historicalInterests.contains(option.id),
        )
        .map((InterestOption option) => option.label)
        .toList();

    return _SettingsGroup(
      title: 'MEIN PROFIL',
      titleColor: AppColors.red,
      children: <Widget>[
        _ProfileRow(
          label: 'Interessen',
          value: interests.isEmpty ? 'Nicht gesetzt' : interests.join(', '),
          onTap: () => _showInterestsSheet(context, ref, profile),
        ),
        const SizedBox(height: 14),
        _ProfileRow(
          label: 'Politische Haltung',
          value: _leaningLabel(profile.politicalLeaning),
          onTap: () => _showLeaningSheet(context, ref, profile),
        ),
        const SizedBox(height: 16),
        _ProfileRow(
          label: 'Zitate auswählen',
          value: _discoveryLabel(profile.quoteDiscoveryMode),
          onTap: () => _showDiscoverySheet(context, ref, profile, sourcesAsync),
        ),
        const SizedBox(height: 14),
        _ProfileRow(
          label: 'Manuelle Quellen',
          value: profile.selectedSources.isEmpty
              ? 'Keine Auswahl'
              : profile.selectedSources.join(', '),
          onTap: () => _showDiscoverySheet(context, ref, profile, sourcesAsync),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => _confirmReset(context, ref),
          child: Text(
            'Profil zuruecksetzen',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDiscoverySheet(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    AsyncValue<List<String>> sourcesAsync,
  ) async {
    final selectedSources = profile.selectedSources.toSet();
    var selectedMode = profile.quoteDiscoveryMode;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'ZITATAUSWAHL',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DiscoveryTile(
                    title: 'Nach Interessen',
                    subtitle: 'Die App gewichtet passende Zitate automatisch.',
                    active: selectedMode == QuoteDiscoveryMode.interests,
                    onTap: () {
                      setSheetState(() {
                        selectedMode = QuoteDiscoveryMode.interests;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _DiscoveryTile(
                    title: 'Manuelle Auswahl',
                    subtitle: 'Du bestimmst die Quellen selbst.',
                    active: selectedMode == QuoteDiscoveryMode.manual,
                    onTap: () {
                      setSheetState(() {
                        selectedMode = QuoteDiscoveryMode.manual;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (selectedMode == QuoteDiscoveryMode.manual) ...<Widget>[
                    Text(
                      'QUELLEN AUSWAEHLEN',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    sourcesAsync.when(
                      data: (sources) {
                        return SizedBox(
                          height: 260,
                          child: ListView.separated(
                            itemCount: sources.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final source = sources[index];
                              final isActive = selectedSources.contains(source);
                              return Material(
                                color: isActive
                                    ? AppColors.ink
                                    : AppColors.paper,
                                child: InkWell(
                                  onTap: () {
                                    setSheetState(() {
                                      if (isActive) {
                                        selectedSources.remove(source);
                                      } else {
                                        selectedSources.add(source);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isActive
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
                                              color: isActive
                                                  ? AppColors.paper
                                                  : AppColors.ink,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isActive
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          size: 18,
                                          color: isActive
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
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, _) => Text('Fehler: $error'),
                    ),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(userProfileProvider.notifier)
                            .updateQuoteDiscoveryMode(selectedMode);
                        await ref
                            .read(userProfileProvider.notifier)
                            .updateSelectedSources(selectedSources.toList());
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        foregroundColor: AppColors.paper,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text('SPEICHERN'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showInterestsSheet(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    final selected = profile.historicalInterests.toSet();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'INTERESSEN BEARBEITEN',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableInterests.map((InterestOption option) {
                      final isActive = selected.contains(option.id);
                      return FilterChip(
                        selected: isActive,
                        onSelected: (_) {
                          setSheetState(() {
                            if (isActive) {
                              selected.remove(option.id);
                            } else {
                              selected.add(option.id);
                            }
                          });
                        },
                        label: Text('${option.icon} ${option.label}'),
                        selectedColor: AppColors.red.withValues(alpha: 0.14),
                        checkmarkColor: AppColors.red,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      );
                    }).toList(),
                  ),
                  if (selected.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Mindestens ein Interesse auswaehlen.',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 10,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selected.isEmpty
                          ? null
                          : () async {
                              await ref
                                  .read(userProfileProvider.notifier)
                                  .updateInterests(selected.toList());
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        foregroundColor: AppColors.paper,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text('SPEICHERN'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showLeaningSheet(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: PoliticalLeaning.values.map((PoliticalLeaning leaning) {
              final isSelected = leaning == profile.politicalLeaning;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_leaningLabel(leaning)),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: AppColors.red)
                    : null,
                onTap: () async {
                  await ref
                      .read(userProfileProvider.notifier)
                      .updatePoliticalLeaning(leaning);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profil zuruecksetzen?'),
          content: const Text(
            'Interessen und politische Haltung werden geloescht. Onboarding wird erneut gezeigt.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Zuruecksetzen'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      await ref.read(userProfileProvider.notifier).resetProfile();
    }
  }

  String _leaningLabel(PoliticalLeaning leaning) {
    switch (leaning) {
      case PoliticalLeaning.left:
        return 'Links';
      case PoliticalLeaning.centerLeft:
        return 'Mitte-Links';
      case PoliticalLeaning.neutral:
        return 'Neutral';
      case PoliticalLeaning.liberal:
        return 'Liberal';
      case PoliticalLeaning.conservative:
        return 'Konservativ';
    }
  }

  String _discoveryLabel(QuoteDiscoveryMode mode) {
    switch (mode) {
      case QuoteDiscoveryMode.interests:
        return 'Nach Interessen';
      case QuoteDiscoveryMode.manual:
        return 'Manuell';
    }
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                color: AppColors.inkLight,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, size: 16),
        ],
      ),
    );
  }
}

class _DiscoveryTile extends StatelessWidget {
  const _DiscoveryTile({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.ink : AppColors.paper,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: active ? AppColors.ink : AppColors.rule),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.title,
    required this.children,
    this.titleColor = AppColors.ink,
  });

  final String title;
  final List<Widget> children;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(
          left: BorderSide(color: AppColors.ink, width: 1),
          right: BorderSide(color: AppColors.ink, width: 1),
          bottom: BorderSide(color: AppColors.ink, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
