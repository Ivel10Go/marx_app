import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/purchases_provider.dart';
import '../../core/services/probe_paywall_service.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/providers/daily_quote_provider.dart';
import '../../domain/providers/settings_provider.dart';
import '../../domain/providers/streak_provider.dart';
import '../../domain/services/tts_service.dart';
import '../../widgets/app_decorated_scaffold.dart';

class PremiumFeaturesScreen extends ConsumerStatefulWidget {
  const PremiumFeaturesScreen({super.key});

  @override
  ConsumerState<PremiumFeaturesScreen> createState() =>
      _PremiumFeaturesScreenState();
}

class _PremiumFeaturesScreenState extends ConsumerState<PremiumFeaturesScreen> {
  static const Map<String, String> _featureTitles = <String, String>{
    'deep_dive': 'Deep Dive Modus',
    'learning_paths': 'Lernpfade / Serien',
    'smart_reminder': 'Smart Reminder 2.0',
    'offline_plus': 'Offline Plus',
    'notes_highlights': 'Pro Notizen & Markierungen',
    'audio_explainer': 'Audio-Erklaerung',
    'knowledge_checks': 'Wissenschecks',
    'weekly_digest': 'Personalisierte Wochenausgabe',
  };

  final Map<String, bool> _trialUnlocked = <String, bool>{};
  final Map<String, int> _remainingTrials = <String, int>{};
  final TextEditingController _noteController = TextEditingController();
  final TtsService _ttsService = TtsService();

  bool _loadingTrials = true;
  bool _offlinePlus = false;
  bool _audioPlaying = false;
  int? _selectedQuizOption;
  bool? _quizCorrect;
  final Set<int> _activeHighlights = <int>{};

  @override
  void initState() {
    super.initState();
    _loadTrialState();
    _loadLocalPremiumPrefs();
    _initTts();
  }

  Future<void> _initTts() async {
    await _ttsService.init();
    _ttsService.onPlaybackCompleted = () async {
      if (mounted) {
        setState(() {
          _audioPlaying = false;
        });
      }
      return;
    };
  }

  Future<void> _loadTrialState() async {
    final remaining = <String, int>{};
    for (final key in _featureTitles.keys) {
      remaining[key] = await ProbePaywallService.remainingUses(key);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _remainingTrials
        ..clear()
        ..addAll(remaining);
      _loadingTrials = false;
    });
  }

  Future<void> _loadLocalPremiumPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final note = prefs.getString('premium_note_text') ?? '';
    final offline = prefs.getBool('premium_offline_plus') ?? false;
    final highlights =
        prefs.getStringList('premium_highlights') ?? const <String>[];

    if (!mounted) {
      return;
    }

    setState(() {
      _noteController.text = note;
      _offlinePlus = offline;
      _activeHighlights
        ..clear()
        ..addAll(highlights.map(int.tryParse).whereType<int>());
    });
  }

  Future<void> _toggleOfflinePlus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('premium_offline_plus', value);
    if (!mounted) {
      return;
    }
    setState(() {
      _offlinePlus = value;
    });
  }

  Future<void> _saveNotesAndHighlights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('premium_note_text', _noteController.text.trim());
    await prefs.setStringList(
      'premium_highlights',
      _activeHighlights.map((value) => value.toString()).toList(),
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notizen und Markierungen gespeichert.')),
    );
  }

  Future<void> _activateTrialOrPaywall(String featureKey) async {
    final result = await ProbePaywallService.consumeAccess(featureKey);
    if (!mounted) {
      return;
    }

    setState(() {
      _remainingTrials[featureKey] = result.remaining;
      if (result.granted) {
        _trialUnlocked[featureKey] = true;
      }
    });

    if (result.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Probezugang aktiv fuer ${_featureTitles[featureKey]}. Verbleibend: ${result.remaining}',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Probe verbraucht. Bitte Pro freischalten.'),
      ),
    );
    context.push('/purchase');
  }

  bool _isUnlocked(String featureKey, bool isPro) {
    if (isPro) {
      return true;
    }
    return _trialUnlocked[featureKey] ?? false;
  }

  TimeOfDay _recommendedSmartTime() {
    final now = TimeOfDay.now();
    final minutes = now.hour * 60 + now.minute;
    if (minutes < 11 * 60) {
      return const TimeOfDay(hour: 19, minute: 0);
    }
    if (minutes < 17 * 60) {
      return const TimeOfDay(hour: 7, minute: 30);
    }
    return const TimeOfDay(hour: 8, minute: 0);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProProvider);
    final dailyQuoteAsync = ref.watch(dailyQuoteProvider);
    final streakAsync = ref.watch(currentStreakProvider);

    return AppDecoratedScaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
        backgroundColor: AppColors.paper,
      ),
      bottomNavigationBar: null,
      child: _loadingTrials
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: <Widget>[
                _HeaderCard(isPro: isPro),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  featureKey: 'deep_dive',
                  subtitle:
                      'Analytische Ebene mit Begriffen und Aktualisierung.',
                  isPro: isPro,
                  child: dailyQuoteAsync.when(
                    data: (quote) {
                      if (quote == null) {
                        return const Text('Kein Tageszitat verfuegbar.');
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Leitthese: ${quote.explanationLong.split('.').first}.',
                          ),
                          const SizedBox(height: 8),
                          Text('Widerspruchspaar: Arbeit vs. Kapital'),
                          const SizedBox(height: 8),
                          Text(
                            'Heute relevant durch Verteilungsfragen und Lohnmacht.',
                          ),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, _) => Text('Fehler: $error'),
                  ),
                ),
                _buildFeatureCard(
                  featureKey: 'learning_paths',
                  subtitle: 'Kuratierte Pfade mit Tagesfortschritt.',
                  isPro: isPro,
                  child: Column(
                    children: const <Widget>[
                      _PathProgressTile(
                        title: 'Arbeit und Entfremdung',
                        progress: 0.35,
                        eta: '9 Tage verbleibend',
                      ),
                      _PathProgressTile(
                        title: 'Staat und Ideologie',
                        progress: 0.14,
                        eta: '12 Tage verbleibend',
                      ),
                      _PathProgressTile(
                        title: 'Klassenanalyse kompakt',
                        progress: 0.72,
                        eta: '3 Tage verbleibend',
                      ),
                    ],
                  ),
                ),
                _buildFeatureCard(
                  featureKey: 'smart_reminder',
                  subtitle:
                      'Adaptive Zeit je nach Lernfenster und Streak-Risiko.',
                  isPro: isPro,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final suggested = _recommendedSmartTime();
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .setNotificationTime(suggested);
                        if (!mounted) {
                          return;
                        }
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Smart Reminder gesetzt auf ${suggested.hour.toString().padLeft(2, '0')}:${suggested.minute.toString().padLeft(2, '0')}.',
                            ),
                          ),
                        );
                      },
                      child: const Text('Empfohlene Zeit anwenden'),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  featureKey: 'offline_plus',
                  subtitle: 'Lokale Caches fuer Lernserien und Exportdaten.',
                  isPro: isPro,
                  child: SwitchListTile.adaptive(
                    value: _offlinePlus,
                    onChanged: _toggleOfflinePlus,
                    title: const Text('Offline Plus aktivieren'),
                    subtitle: const Text('Inhalte werden lokal vorgehalten.'),
                  ),
                ),
                _buildFeatureCard(
                  featureKey: 'notes_highlights',
                  subtitle: 'Notizen und Markierungen auf Zitat-Ebene.',
                  isPro: isPro,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 8,
                        children: List<Widget>.generate(3, (index) {
                          final active = _activeHighlights.contains(index);
                          final labels = <String>[
                            'Begriff',
                            'Kritik',
                            'Praxis',
                          ];
                          return FilterChip(
                            selected: active,
                            label: Text(labels[index]),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _activeHighlights.add(index);
                                } else {
                                  _activeHighlights.remove(index);
                                }
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _noteController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Deine Notiz',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton(
                          onPressed: _saveNotesAndHighlights,
                          child: const Text('Notiz speichern'),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFeatureCard(
                  featureKey: 'audio_explainer',
                  subtitle: 'Vorlesemodus fuer Kurz- und Deep-Dive-Erklaerung.',
                  isPro: isPro,
                  child: dailyQuoteAsync.when(
                    data: (quote) {
                      if (quote == null) {
                        return const Text('Kein Tageszitat verfuegbar.');
                      }
                      return Row(
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_audioPlaying) {
                                await _ttsService.stop();
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  _audioPlaying = false;
                                });
                                return;
                              }
                              setState(() {
                                _audioPlaying = true;
                              });
                              await _ttsService.speak(
                                '${quote.explanationShort} ${quote.explanationLong}',
                              );
                            },
                            icon: Icon(
                              _audioPlaying
                                  ? Icons.stop_circle_outlined
                                  : Icons.play_circle_outline,
                            ),
                            label: Text(_audioPlaying ? 'Stoppen' : 'Anhoeren'),
                          ),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, _) => Text('Fehler: $error'),
                  ),
                ),
                _buildFeatureCard(
                  featureKey: 'knowledge_checks',
                  subtitle: 'Adaptive Quizfragen fuer Lernkontrolle.',
                  isPro: isPro,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Frage: Wofuer steht "Entfremdung" bei Marx am ehesten?',
                      ),
                      const SizedBox(height: 8),
                      ...List<Widget>.generate(3, (index) {
                        const options = <String>[
                          'Individuelle Faulheit',
                          'Trennung von Arbeit und menschlichem Wesen',
                          'Nur ein politischer Begriff ohne Wirtschaftsbezug',
                        ];
                        final isSelected = _selectedQuizOption == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ChoiceChip(
                            selected: isSelected,
                            label: Text(options[index]),
                            onSelected: (_) {
                              setState(() {
                                _selectedQuizOption = index;
                                _quizCorrect = index == 1;
                              });
                            },
                          ),
                        );
                      }),
                      if (_quizCorrect != null)
                        Text(
                          _quizCorrect!
                              ? 'Richtig. Gute Einordnung.'
                              : 'Noch nicht ganz. Tipp: Es geht um Arbeit und Selbstbezug.',
                          style: TextStyle(
                            color: _quizCorrect! ? Colors.green : AppColors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildFeatureCard(
                  featureKey: 'weekly_digest',
                  subtitle: 'Personalisierte Wochenzusammenfassung.',
                  isPro: isPro,
                  child: streakAsync.when(
                    data: (streak) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Aktueller Streak: $streak Tage'),
                        const SizedBox(height: 6),
                        Text(
                          _offlinePlus
                              ? 'Offline Plus ist aktiv: Wochenausgabe wird lokal vorbereitet.'
                              : 'Aktiviere Offline Plus, um die Wochenausgabe lokal vorzuhalten.',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Top-Thema dieser Woche: Arbeit und Produktivitaet',
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Wochenausgabe erstellt (MVP-Demo).',
                                ),
                              ),
                            );
                          },
                          child: const Text('Wochenausgabe erzeugen'),
                        ),
                      ],
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, _) => Text('Fehler: $error'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFeatureCard({
    required String featureKey,
    required String subtitle,
    required bool isPro,
    required Widget child,
  }) {
    final isUnlocked = _isUnlocked(featureKey, isPro);
    final remaining = _remainingTrials[featureKey] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _featureTitles[featureKey] ?? featureKey,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppColors.red : AppColors.paper,
                    border: Border.all(color: AppColors.ink, width: 1),
                  ),
                  child: Text(
                    isUnlocked ? 'AKTIV' : 'PROBE',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: isUnlocked ? Colors.white : AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                color: AppColors.inkLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            if (isUnlocked)
              child
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Probezugriffe uebrig: $remaining',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _activateTrialOrPaywall(featureKey),
                        child: const Text('Probe starten'),
                      ),
                      OutlinedButton(
                        onPressed: () => context.push('/purchase'),
                        child: const Text('Pro freischalten'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.isPro});

  final bool isPro;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'PREMIUM LAB',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Alle Premium Features als Probe oder mit Pro-Zugang.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPro
                ? 'Pro ist aktiv: Alle Features sind freigeschaltet.'
                : 'Jedes Feature hat eine begrenzte Probe. Danach greift die Paywall.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: AppColors.inkLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PathProgressTile extends StatelessWidget {
  const _PathProgressTile({
    required this.title,
    required this.progress,
    required this.eta,
  });

  final String title;
  final double progress;
  final String eta;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.rule, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: progress, color: AppColors.red),
          const SizedBox(height: 6),
          Text(
            eta,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              color: AppColors.inkLight,
            ),
          ),
        ],
      ),
    );
  }
}
