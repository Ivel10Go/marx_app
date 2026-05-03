import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../domain/providers/user_profile_provider.dart';
import '../../widgets/parlamentz.dart';

class PoliticalOrientationTestScreen extends ConsumerStatefulWidget {
  const PoliticalOrientationTestScreen({super.key});

  @override
  ConsumerState<PoliticalOrientationTestScreen> createState() =>
      _PoliticalOrientationTestScreenState();
}

class _PoliticalOrientationTestScreenState
    extends ConsumerState<PoliticalOrientationTestScreen> {
  static const List<_PoliticalPrompt> _prompts = <_PoliticalPrompt>[
    _PoliticalPrompt(
      statement: 'Der Staat sollte Ungleichheit aktiv ausgleichen.',
      subtitle: 'Umverteilung und soziale Sicherheit',
    ),
    _PoliticalPrompt(
      statement: 'Freiheit ist wichtiger als staatliche Eingriffe.',
      subtitle: 'Ordnung, Eigenverantwortung, Regulierung',
    ),
    _PoliticalPrompt(
      statement: 'Große Unternehmen brauchen stärkere Kontrolle.',
      subtitle: 'Markt, Macht und Aufsicht',
    ),
    _PoliticalPrompt(
      statement: 'Traditionen sollten nur verändert werden, wenn es nötig ist.',
      subtitle: 'Wandel, Stabilität und Werte',
    ),
    _PoliticalPrompt(
      statement:
          'Der Staat soll sich aus persönlichen Lebensentscheidungen eher heraushalten.',
      subtitle: 'Privatsphäre und Selbstbestimmung',
    ),
    _PoliticalPrompt(
      statement:
          'Öffentliche Güter wie Bildung und Gesundheit sollten stark abgesichert sein.',
      subtitle: 'Gemeinwohl und Infrastruktur',
    ),
  ];

  int _index = 0;
  final List<int> _scores = <int>[];
  bool _saving = false;
  PoliticalLeaning? _result;

  Future<void> _recordAnswer(bool agree) async {
    if (_saving || _index >= _prompts.length) {
      return;
    }

    _scores.add(agree ? 1 : -1);

    setState(() {
      _index += 1;
    });

    if (_index == _prompts.length) {
      final leaning = _inferLeaning();
      setState(() {
        _result = leaning;
        _saving = true;
      });
      await ref
          .read(userProfileProvider.notifier)
          .updatePoliticalLeaning(leaning);
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Politische Orientierung gespeichert.')),
      );
      return;
    }
  }

  PoliticalLeaning _inferLeaning() {
    if (_scores.isEmpty) {
      return PoliticalLeaning.neutral;
    }

    final average = _scores.reduce((int a, int b) => a + b) / _scores.length;
    if (average <= -0.6) {
      return PoliticalLeaning.left;
    }
    if (average <= -0.2) {
      return PoliticalLeaning.centerLeft;
    }
    if (average < 0.2) {
      return PoliticalLeaning.neutral;
    }
    if (average < 0.6) {
      return PoliticalLeaning.liberal;
    }
    return PoliticalLeaning.conservative;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasMoreCards = _index < _prompts.length;
    final prompt = hasMoreCards ? _prompts[_index] : null;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        title: Text(
          'Orientierungstest',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _OrientationIntroCard(),
              const SizedBox(height: 12),
              Text(
                'Wische nach rechts für Zustimmung, nach links für Ablehnung.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: _prompts.isEmpty ? 0 : _index / _prompts.length,
                minHeight: 2,
                backgroundColor: scheme.outline,
                color: AppColors.red,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: hasMoreCards
                        ? Dismissible(
                            key: ValueKey<String>(prompt!.statement),
                            direction: DismissDirection.horizontal,
                            background: _SwipeBackdrop(
                              label: 'STIMME ZU',
                              color: scheme.primary,
                              icon: Icons.thumb_up_alt_rounded,
                              alignEnd: false,
                            ),
                            secondaryBackground: _SwipeBackdrop(
                              label: 'STIMME NICHT ZU',
                              color: scheme.error,
                              icon: Icons.thumb_down_alt_rounded,
                              alignEnd: true,
                            ),
                            onDismissed: (direction) {
                              _recordAnswer(
                                direction == DismissDirection.startToEnd,
                              );
                            },
                            child: _PromptCard(
                              prompt: prompt,
                              index: _index + 1,
                              total: _prompts.length,
                              onAgree: () => _recordAnswer(true),
                              onDisagree: () => _recordAnswer(false),
                            ),
                          )
                        : _ResultCard(
                            result: _result ?? PoliticalLeaning.neutral,
                            onDone: () => context.pop(),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrientationIntroCard extends StatelessWidget {
  const _OrientationIntroCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'EINORDNUNG',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Die Antworten helfen dabei, Inhalte und Empfehlungen besser auf deine Haltung abzustimmen.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PoliticalPrompt {
  const _PoliticalPrompt({required this.statement, required this.subtitle});

  final String statement;
  final String subtitle;
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.prompt,
    required this.index,
    required this.total,
    required this.onAgree,
    required this.onDisagree,
  });

  final _PoliticalPrompt prompt;
  final int index;
  final int total;
  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      key: key,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline, width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'AUSSAGE $index / $total',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            prompt.statement,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            prompt.subtitle,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: _ActionPill(
                  label: 'ABLEHNEN',
                  onTap: onDisagree,
                  outline: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionPill(
                  label: 'ZUSTIMMEN',
                  onTap: onAgree,
                  outline: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.label,
    required this.onTap,
    required this.outline,
  });

  final String label;
  final VoidCallback onTap;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: outline ? Colors.transparent : scheme.onSurface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outline, width: 1),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: outline ? scheme.onSurface : scheme.surface,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeBackdrop extends StatelessWidget {
  const _SwipeBackdrop({
    required this.label,
    required this.color,
    required this.icon,
    required this.alignEnd,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: alignEnd
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          if (!alignEnd) ...<Widget>[
            Icon(icon, color: color),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.1,
            ),
          ),
          if (alignEnd) ...<Widget>[
            const SizedBox(width: 8),
            Icon(icon, color: color),
          ],
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.onDone});

  final PoliticalLeaning result;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: ParlamentzIndicator(leaning: result, size: 84)),
          const SizedBox(height: 12),
          Text(
            'ERGEBNIS',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _labelForResult(result),
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Dein Profil wurde gespeichert und kann später im Profil jederzeit angepasst werden.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Damit sind die Empfehlungen und die persönliche Einordnung vorbereitet.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: _ActionPill(label: 'FERTIG', onTap: onDone, outline: false),
          ),
        ],
      ),
    );
  }

  String _labelForResult(PoliticalLeaning result) {
    switch (result) {
      case PoliticalLeaning.left:
        return 'Links';
      case PoliticalLeaning.centerLeft:
        return 'Links der Mitte';
      case PoliticalLeaning.neutral:
        return 'Neutral';
      case PoliticalLeaning.liberal:
        return 'Liberal';
      case PoliticalLeaning.conservative:
        return 'Konservativ';
    }
  }
}
