import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/quote.dart';
import '../../domain/providers/repository_providers.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';

enum _GameMode { source, yearCompare }

class GamesScreen extends ConsumerStatefulWidget {
  const GamesScreen({super.key});

  @override
  ConsumerState<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends ConsumerState<GamesScreen> {
  final Random _random = Random();
  _GameMode? _selectedGame;
  Quote? _sourceQuestion;
  List<String> _sourceOptions = <String>[];
  String? _sourceFeedback;
  bool _sourceAnswered = false;

  Quote? _yearLeft;
  Quote? _yearRight;
  String? _yearFeedback;
  bool _yearAnswered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareGames();
    });
  }

  Future<void> _prepareGames() async {
    await ref.read(initialSeedProvider.future);
    final quotes = await ref
        .read(quoteRepositoryProvider)
        .watchAllQuotes()
        .first;
    if (quotes.length < 4 || !mounted) {
      return;
    }

    final sourceQuestion = quotes[_random.nextInt(quotes.length)];
    final sourceOptions = <String>{sourceQuestion.source};
    while (sourceOptions.length < 4) {
      sourceOptions.add(quotes[_random.nextInt(quotes.length)].source);
    }

    final left = quotes[_random.nextInt(quotes.length)];
    var right = quotes[_random.nextInt(quotes.length)];
    while (right.id == left.id) {
      right = quotes[_random.nextInt(quotes.length)];
    }

    setState(() {
      _sourceQuestion = sourceQuestion;
      _sourceOptions = sourceOptions.toList()..shuffle(_random);
      _sourceFeedback = null;
      _sourceAnswered = false;
      _yearLeft = left;
      _yearRight = right;
      _yearFeedback = null;
      _yearAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: <Widget>[
          Container(
            color: AppColors.paper,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'MINIGAMES',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(width: 40, height: 2, color: AppColors.red),
                const SizedBox(height: 12),
                Text(
                  'Wähle zuerst ein Spiel. Danach wird nur die gewählte Runde gezeigt.',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: AppColors.inkLight,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _GameCard(
            title: 'SPIELE AUSWAEHLEN',
            subtitle:
                'Starte mit einer Karte und zeige danach nur die gewählte Runde.',
            child: Column(
              children: <Widget>[
                _GameChoiceTile(
                  title: 'WER HAT DAS GESAGT?',
                  subtitle: 'Ordne das Zitat der richtigen Quelle zu.',
                  active: _selectedGame == _GameMode.source,
                  onTap: () {
                    setState(() {
                      _selectedGame = _GameMode.source;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _GameChoiceTile(
                  title: 'WELCHES ZITAT IST AELTER?',
                  subtitle: 'Wähle das frühere Jahr.',
                  active: _selectedGame == _GameMode.yearCompare,
                  onTap: () {
                    setState(() {
                      _selectedGame = _GameMode.yearCompare;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_selectedGame == null)
            _GameCard(
              title: 'START',
              subtitle: 'Wähle oben ein Spiel aus, um die Runde zu beginnen.',
              child: _GameLoading(message: 'Noch kein Spiel ausgewählt.'),
            )
          else if (_selectedGame == _GameMode.source)
            _GameCard(
              title: 'WER HAT DAS GESAGT?',
              subtitle: 'Ordne das Zitat der richtigen Quelle zu.',
              child: _sourceQuestion == null
                  ? const _GameLoading()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '»${_sourceQuestion!.textDe}«',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.ink,
                            height: 1.55,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._sourceOptions.map((option) {
                          final isCorrect = option == _sourceQuestion!.source;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: _sourceAnswered && isCorrect
                                  ? AppColors.ink
                                  : AppColors.paper,
                              child: InkWell(
                                onTap: _sourceAnswered
                                    ? null
                                    : () {
                                        setState(() {
                                          _sourceAnswered = true;
                                          _sourceFeedback = isCorrect
                                              ? 'Richtig: ${_sourceQuestion!.source}'
                                              : 'Falsch. Richtig ist ${_sourceQuestion!.source}';
                                        });
                                      },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _sourceAnswered && isCorrect
                                          ? AppColors.ink
                                          : AppColors.rule,
                                    ),
                                  ),
                                  child: Text(
                                    option,
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _sourceAnswered && isCorrect
                                          ? AppColors.paper
                                          : AppColors.ink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        if (_sourceFeedback != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Text(
                            _sourceFeedback!,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppColors.inkLight,
                            ),
                          ),
                        ],
                      ],
                    ),
            )
          else
            _GameCard(
              title: 'WELCHES ZITAT IST AELTER?',
              subtitle: 'Wähle das frühere Jahr.',
              child: _yearLeft == null || _yearRight == null
                  ? const _GameLoading()
                  : Column(
                      children: <Widget>[
                        _YearChoiceTile(
                          quote: _yearLeft!,
                          onTap: _yearAnswered
                              ? null
                              : () {
                                  final correct =
                                      _yearLeft!.year <= _yearRight!.year;
                                  setState(() {
                                    _yearAnswered = true;
                                    _yearFeedback = correct
                                        ? 'Richtig, die linke Quote ist aelter.'
                                        : 'Falsch, die rechte Quote ist aelter.';
                                  });
                                },
                        ),
                        const SizedBox(height: 10),
                        _YearChoiceTile(
                          quote: _yearRight!,
                          onTap: _yearAnswered
                              ? null
                              : () {
                                  final correct =
                                      _yearRight!.year < _yearLeft!.year;
                                  setState(() {
                                    _yearAnswered = true;
                                    _yearFeedback = correct
                                        ? 'Richtig, die rechte Quote ist aelter.'
                                        : 'Falsch, die linke Quote ist aelter.';
                                  });
                                },
                        ),
                        if (_yearFeedback != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Text(
                            _yearFeedback!,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppColors.inkLight,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          const SizedBox(height: 14),
          _GameCard(
            title: 'NEU LADEN',
            subtitle: 'Ziehe neue Zitate für die nächste Runde.',
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: AppColors.ink,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedGame = null;
                    });
                    _prepareGames();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      'NEUE RUNDE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.paper,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

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
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: AppColors.inkLight,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _GameChoiceTile extends StatelessWidget {
  const _GameChoiceTile({
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
          width: double.infinity,
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

class _YearChoiceTile extends StatelessWidget {
  const _YearChoiceTile({required this.quote, required this.onTap});

  final Quote quote;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final yearLabel = quote.year < 0
        ? '${quote.year.abs()} v. Chr.'
        : '${quote.year}';
    return Material(
      color: AppColors.paper,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(border: Border.all(color: AppColors.rule)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                quote.source,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.red,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Jahr: $yearLabel',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameLoading extends StatelessWidget {
  const _GameLoading({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
            ),
          ),
          if (message != null) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                color: AppColors.inkLight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
