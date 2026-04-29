import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/daily_content.dart';
import '../../data/models/home_content_mode.dart';
import '../../domain/providers/admin_access_provider.dart';
import '../../domain/providers/app_mode_provider.dart';
import '../../domain/providers/premium_provider.dart';
import '../../domain/providers/daily_content_provider.dart';
import '../../domain/providers/settings_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../loading/app_loading_screen.dart';
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
                  'Demnächst verfügbar:',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                const _PremiumFeatureRow(
                  title: 'Tiefere Erklärungen',
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
                  subtitle: 'Spaced-Learning Hinweise für nachhaltiges Lernen',
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
      bottomNavigationBar: const AppNavigationBar(selectedIndex: 2),
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
                const SizedBox(height: 10),
                Text(
                  'Steuere, was du täglich siehst und wie du lernst.',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: AppColors.inkLight,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: settingsAsync.when(
              data: (settings) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  children: <Widget>[
                    const _SettingsHeroCard(),
                    const SizedBox(height: 16),
                    const ProfileSection(),
                    const SizedBox(height: 20),
                    _SettingsGroup(
                      title: 'STARTBILDSCHIRM',
                      children: <Widget>[
                        Text(
                          'Wähle, ob du heute ein Zitat, einen historischen Fun-Fact oder beides im Zufallsmodus sehen willst.',
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
                              child: _SettingsChoiceButton(
                                label: 'ZITATE',
                                subtitle: 'Tageszitat mit Kontext',
                                selected:
                                    settings.homeContentMode ==
                                    HomeContentMode.quotes,
                                onTap: () async {
                                  await ref
                                      .read(settingsControllerProvider.notifier)
                                      .setHomeContentMode(
                                        HomeContentMode.quotes,
                                      );
                                  ref.invalidate(dailyContentProvider);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _SettingsChoiceButton(
                                label: 'FUN FACTS',
                                subtitle: 'Historische Wissenshappen',
                                selected:
                                    settings.homeContentMode ==
                                    HomeContentMode.facts,
                                onTap: () async {
                                  await ref
                                      .read(settingsControllerProvider.notifier)
                                      .setHomeContentMode(
                                        HomeContentMode.facts,
                                      );
                                  ref.invalidate(dailyContentProvider);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _SettingsChoiceButton(
                                label: 'ZUFALL',
                                subtitle: 'Abwechselnd Zitat/Fun-Fact',
                                selected:
                                    settings.homeContentMode ==
                                    HomeContentMode.mixed,
                                onTap: () async {
                                  await ref
                                      .read(settingsControllerProvider.notifier)
                                      .setHomeContentMode(
                                        HomeContentMode.mixed,
                                      );
                                  ref.invalidate(dailyContentProvider);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _SettingsModePreview(mode: settings.homeContentMode),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                            const SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _ThemeOption(
                                    label: 'Hell',
                                    themeMode: ThemeMode.light,
                                    isSelected:
                                        settings.themeMode == ThemeMode.light,
                                    onTap: () {
                                      ref
                                          .read(
                                            settingsControllerProvider.notifier,
                                          )
                                          .setThemeMode(ThemeMode.light);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ThemeOption(
                                    label: 'Dunkel',
                                    themeMode: ThemeMode.dark,
                                    isSelected:
                                        settings.themeMode == ThemeMode.dark,
                                    onTap: () {
                                      ref
                                          .read(
                                            settingsControllerProvider.notifier,
                                          )
                                          .setThemeMode(ThemeMode.dark);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ThemeOption(
                                    label: 'System',
                                    themeMode: ThemeMode.system,
                                    isSelected:
                                        settings.themeMode == ThemeMode.system,
                                    onTap: () {
                                      ref
                                          .read(
                                            settingsControllerProvider.notifier,
                                          )
                                          .setThemeMode(ThemeMode.system);
                                    },
                                  ),
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
                              'Erklärungssprache',
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
                                    'Täglich aktiv',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Bei Aktivierung wird dein Tagesinhalt (Zitat oder Fact) jeden Tag zur Uhrzeit geplant.',
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
                          'Dezentes Upgrade für mehr Lerntiefe. Basisfunktionen bleiben frei.',
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
                        const SizedBox(height: 16),
                        // ─── Premium Test Toggle (DEV) ──────────────
                        Consumer(
                          builder: (context, ref, _) {
                            final isPremium = ref
                                .watch(isPremiumProvider)
                                .maybeWhen(
                                  data: (value) => value,
                                  orElse: () => false,
                                );
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Premium Testen',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 10,
                                    color: AppColors.inkLight,
                                  ),
                                ),
                                Switch(
                                  value: isPremium,
                                  onChanged: (value) {
                                    ref
                                        .read(isPremiumProvider.notifier)
                                        .setPremium(value);
                                  },
                                ),
                              ],
                            );
                          },
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
                child: AppLoadingScreen(
                  title: 'Einstellungen werden geladen',
                  subtitle: 'Profil, Modus und Benachrichtigungen …',
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
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.ink, width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
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
            color: AppColors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Text(
              title,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
          Container(height: 1, color: AppColors.rule),
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

class _SettingsHeroCard extends StatelessWidget {
  const _SettingsHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: AppColors.red,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'PERSÖNLICHER FEED',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Passe den Feed an: Zitate für Tiefe, Fakten für schnelles historisches Lernen oder Zufall für Abwechslung.',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsModePreview extends StatelessWidget {
  const _SettingsModePreview({required this.mode});

  final HomeContentMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'VORSCHAU',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              );
            },
            child: _previewTileForMode(mode),
          ),
        ],
      ),
    );
  }

  Widget _previewTileForMode(HomeContentMode mode) {
    switch (mode) {
      case HomeContentMode.quotes:
        return _PreviewTile(
          key: const ValueKey<String>('quotes'),
          kicker: 'ZITATATLAS',
          title: 'Tageszitat mit Einordnung',
          subtitle: 'Ideal für konzentriertes Lesen mit Kontext.',
        );
      case HomeContentMode.facts:
        return _PreviewTile(
          key: const ValueKey<String>('facts'),
          kicker: 'WELTGESCHICHTE',
          title: 'Historischer Fun-Fact',
          subtitle: 'Kurzer Wissenshappen für nebenbei Lernen.',
        );
      case HomeContentMode.mixed:
        return _PreviewTile(
          key: const ValueKey<String>('mixed'),
          kicker: 'ZUFALLSMODUS',
          title: 'Abwechslung pro Tag',
          subtitle: 'App zeigt wechselnd Zitat oder Fun-Fact.',
        );
    }
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.kicker,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String kicker;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paperDark,
        border: Border.all(color: AppColors.rule, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            kicker,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
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
    );
  }
}

class _SettingsChoiceButton extends StatelessWidget {
  const _SettingsChoiceButton({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedBg = AppColors.red.withValues(alpha: 0.1);
    final selectedBorder = AppColors.red.withValues(alpha: 0.85);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? selectedBg : AppColors.paper,
            border: Border.all(
              color: selected ? selectedBorder : AppColors.ink,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 4,
                width: double.infinity,
                color: selected ? AppColors.red : AppColors.rule,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: selected ? AppColors.ink : AppColors.ink,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_box_rounded
                        : Icons.crop_square_rounded,
                    size: 16,
                    color: selected ? AppColors.red : AppColors.inkLight,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                width: double.infinity,
                color: selected
                    ? AppColors.paper.withValues(alpha: 0.25)
                    : AppColors.rule,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  height: 1.4,
                  color: selected
                      ? AppColors.ink.withValues(alpha: 0.78)
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
    final bg = filled ? AppColors.red : Colors.transparent;
    final border = filled ? AppColors.redDark : AppColors.ink;

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

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.themeMode,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final ThemeMode themeMode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.red : AppColors.ink,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.zero,
          color: isSelected ? AppColors.paper : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Icons.check_circle, color: AppColors.red, size: 16),
              ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
