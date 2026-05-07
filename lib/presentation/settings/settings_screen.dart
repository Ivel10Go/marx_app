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
import '../../widgets/android_back_guard.dart';
import '../../widgets/app_navigation_bar.dart';
import '../loading/app_loading_screen.dart';
import 'widgets/profile_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final settingsAsync = ref.watch(settingsControllerProvider);
    final appMode = ref.watch(appModeNotifierProvider);
    final isAdmin = ref.watch(adminAccessProvider);

    return AndroidBackGuard(
      child: AppDecoratedScaffold(
        appBar: null,
        bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
        child: Column(
          children: <Widget>[
            // Masthead
            Container(
              color: scheme.surface,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'EINSTELLUNGEN',
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
                    'Steuere, was du täglich siehst und wie du lernst.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox.shrink(),
            Expanded(
              child: settingsAsync.when(
                data: (settings) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    children: <Widget>[
                      const ProfileSection(),
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
                                      'Täglich aktiv',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Bei Aktivierung wird dein Tagesinhalt (Zitat oder Fact) jeden Tag zur gewählten Uhrzeit geplant.',
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
                                onChanged: (bool enabled) async {
                                  try {
                                    await ref
                                        .read(
                                          settingsControllerProvider.notifier,
                                        )
                                        .setNotificationEnabled(enabled);
                                  } catch (e) {
                                    if (!context.mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Benachrichtigung konnte nicht aktualisiert werden: $e',
                                        ),
                                      ),
                                    );
                                  }
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
                                try {
                                  await ref
                                      .read(settingsControllerProvider.notifier)
                                      .setNotificationTime(selected);
                                } catch (e) {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Benachrichtigungszeit konnte nicht gespeichert werden: $e',
                                      ),
                                    ),
                                  );
                                }
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
                        title: 'SAMMLUNG',
                        children: <Widget>[
                          Text(
                            'Deine gespeicherten Inhalte bleiben erreichbar, ohne den Lesefluss auf anderen Seiten zu stören.',
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
                                          .read(
                                            appModeNotifierProvider.notifier,
                                          )
                                          .set(AppMode.adminMarx);
                                      ref.invalidate(dailyContentProvider);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Marx-Modus aktiviert',
                                            ),
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
                          Text(
                            'Diese Werkzeuge sind für Pflege und Rücksetzung gedacht, nicht für den regulären Tagesgebrauch.',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppColors.inkLight,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: _SettingsActionButton(
                              label: 'EINFÜHRUNG ERNEUT ANSEHEN',
                              filled: false,
                              onTap: () => context.push('/onboarding'),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                    settings.onboardingSeen
                                        ? 'Gesehen'
                                        : 'Offen',
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
                                    'Streak zurücksetzen',
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
                  child: AppInlineLoadingState(
                    title: 'Einstellungen werden geladen',
                    subtitle: 'Profil, Modus und Benachrichtigungen …',
                  ),
                ),
                error: (error, _) => AppInlineErrorState(
                  title: 'Einstellungen konnten nicht geladen werden',
                  message: 'Fehler: $error',
                  onRetry: () => ref.invalidate(settingsControllerProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings intro/tip card removed per scope-reduction request.

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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline, width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: scheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Text(
              title,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: scheme.onPrimary,
              ),
            ),
          ),
          Container(height: 1, color: scheme.outline),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[...children],
            ),
          ),
        ],
      ),
    );
  }
}

// Settings hero/tip card removed per scope-reduction request.

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
    final scheme = Theme.of(context).colorScheme;
    final bg = filled ? AppColors.red : Colors.transparent;
    final border = filled ? AppColors.redDark : scheme.outline;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1),
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
                color: filled ? scheme.surface : scheme.onSurface,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
