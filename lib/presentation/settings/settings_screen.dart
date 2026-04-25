import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/daily_content.dart';
import '../../domain/providers/admin_access_provider.dart';
import '../../domain/providers/app_mode_provider.dart';
import '../../domain/providers/daily_content_provider.dart';
import '../../domain/providers/settings_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import 'widgets/profile_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showPremiumTeaserSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(width: 44, height: 2, color: AppColors.red),
                const SizedBox(height: 14),
                Text(
                  'PREMIUM VORSCHAU',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Demnaechst verfuegbar:',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                const _PremiumFeatureRow(
                  title: 'Tiefere Erklaerungen',
                  subtitle: 'Mehrschichtige Einordnung jedes Tageszitats',
                ),
                const SizedBox(height: 10),
                const _PremiumFeatureRow(
                  title: 'Kuratierte Lernserien',
                  subtitle: 'Wochenpfade zu Themen wie Arbeit, Macht und Ethik',
                ),
                const SizedBox(height: 10),
                const _PremiumFeatureRow(
                  title: 'Smart-Reminder',
                  subtitle: 'Spaced-Learning Hinweise fuer nachhaltiges Lernen',
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: _SettingsActionButton(
                    label: 'VERSTANDEN',
                    onTap: () => Navigator.of(sheetContext).pop(),
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final appMode = ref.watch(appModeNotifierProvider);
    final isAdmin = ref.watch(adminAccessProvider);

    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: const AppNavigationBar(selectedIndex: 1),
      child: Column(
        children: <Widget>[
          // Masthead
          Container(
            color: AppColors.paper,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'EINSTELLUNGEN',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(width: 40, height: 2, color: AppColors.red),
              ],
            ),
          ),
          Expanded(
            child: settingsAsync.when(
              data: (settings) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  children: <Widget>[
                    const ProfileSection(),
                    const SizedBox(height: 24),
                    _SettingsGroup(
                      title: 'DARSTELLUNG',
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Theme',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Hell (Broadsheet)',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 10,
                                    color: AppColors.inkLight,
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.red,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Erklaerungssprache',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 140,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: settings.languageCode,
                                onChanged: (String? value) {
                                  if (value != null) {
                                    ref
                                        .read(
                                          settingsControllerProvider.notifier,
                                        )
                                        .setLanguageCode(value);
                                  }
                                },
                                items: const <DropdownMenuItem<String>>[
                                  DropdownMenuItem(
                                    value: 'de',
                                    child: Text('Deutsch'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'en',
                                    child: Text('English'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SettingsGroup(
                      title: 'BENACHRICHTIGUNGEN',
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Taeglich aktiv',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Bei Aktivierung wird das Tageszitat jeden Tag zur Uhrzeit geplant.',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 10,
                                      color: AppColors.inkLight,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: settings.notificationEnabled,
                              onChanged: (bool enabled) {
                                ref
                                    .read(settingsControllerProvider.notifier)
                                    .setNotificationEnabled(enabled);
                              },
                              activeThumbColor: AppColors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () async {
                            if (!settings.notificationEnabled) {
                              return;
                            }

                            final selected = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: settings.notificationHour,
                                minute: settings.notificationMinute,
                              ),
                            );
                            if (selected != null && context.mounted) {
                              await ref
                                  .read(settingsControllerProvider.notifier)
                                  .setNotificationTime(selected);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Benachrichtigungszeit',
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: settings.notificationEnabled
                                      ? AppColors.ink
                                      : AppColors.inkLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${settings.notificationHour.toString().padLeft(2, '0')}:${settings.notificationMinute.toString().padLeft(2, '0')}',
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 10,
                                  color: settings.notificationEnabled
                                      ? AppColors.inkLight
                                      : const Color(0xFF9D9D9D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SettingsGroup(
                      title: 'PREMIUM',
                      children: <Widget>[
                        Text(
                          'Dezentes Upgrade fuer mehr Lerntiefe. Basisfunktionen bleiben frei.',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            color: AppColors.inkLight,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _SettingsActionButton(
                                label: 'MEHR ERFAHREN',
                                filled: false,
                                onTap: () => _showPremiumTeaserSheet(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SettingsGroup(
                      title: 'SAMMLUNG',
                      children: <Widget>[
                        Text(
                          'Deine gespeicherten Inhalte ohne den Lesefluss zu unterbrechen.',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            color: AppColors.inkLight,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _SettingsActionButton(
                                label: 'FAVORITEN',
                                filled: false,
                                onTap: () => context.push('/favorites'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _SettingsActionButton(
                                label: 'ARCHIV',
                                filled: false,
                                onTap: () => context.push('/archive'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (isAdmin) ...<Widget>[
                      _SettingsGroup(
                        title: 'ADMIN',
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Aktiver Modus',
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                _modeLabel(appMode),
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: _SettingsActionButton(
                                  label: 'ADMIN DASHBOARD',
                                  filled: false,
                                  onTap: () => context.push('/admin'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _SettingsActionButton(
                                  label: 'MARX MODUS',
                                  filled: true,
                                  onTap: () async {
                                    await ref
                                        .read(appModeNotifierProvider.notifier)
                                        .set(AppMode.adminMarx);
                                    ref.invalidate(dailyContentProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Marx-Modus aktiviert'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                    _SettingsGroup(
                      title: 'WARTUNG',
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Onboarding-Status',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  settings.onboardingSeen ? 'Gesehen' : 'Offen',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 10,
                                    color: AppColors.inkLight,
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => ref
                                    .read(settingsControllerProvider.notifier)
                                    .markOnboardingSeen(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'ANWENDEN',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.red,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Streak zuruecksetzen',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Setzt den aktuellen Serien-Status auf null.',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 10,
                                    color: AppColors.inkLight,
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => ref
                                    .read(settingsControllerProvider.notifier)
                                    .resetStreak(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.restart_alt_rounded,
                                    color: AppColors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
                ),
              ),
              error: (error, _) => Center(child: Text('Fehler: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

String _modeLabel(AppMode mode) {
  switch (mode) {
    case AppMode.public:
      return 'Für alle';
    case AppMode.adminMarx:
      return 'Marx-Modus';
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

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
                color: AppColors.ink,
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

class _SettingsActionButton extends StatelessWidget {
  const _SettingsActionButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? AppColors.ink : Colors.transparent,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: filled ? AppColors.paper : AppColors.ink,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumFeatureRow extends StatelessWidget {
  const _PremiumFeatureRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(
            Icons.check_circle_outline,
            size: 14,
            color: AppColors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  color: AppColors.inkLight,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
