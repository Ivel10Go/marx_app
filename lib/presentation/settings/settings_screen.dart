import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/providers/settings_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import 'widgets/profile_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
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
                        GestureDetector(
                          onTap: () async {
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
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${settings.notificationHour.toString().padLeft(2, '0')}:${settings.notificationMinute.toString().padLeft(2, '0')}',
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 10,
                                  color: AppColors.inkLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
