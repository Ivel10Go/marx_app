import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/notification_service.dart';
import '../../core/services/widget_sync_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/share_card_renderer.dart';
import '../../data/models/quote.dart';
import '../../domain/providers/daily_content_provider.dart';
import '../../domain/providers/streak_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/adaptive_quote_text.dart';
import '../../widgets/quote_card.dart';
import '../../widgets/streak_badge.dart';
import '../home/widgets/fact_block.dart';
import '../home/widgets/streak_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  bool _calendarExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(streakControllerProvider.notifier).logTodayAndRefresh();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyContent = ref.watch(dailyContentProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    // Sync widget whenever daily content and streak are available
    ref.listen(dailyContentProvider, (_, next) {
      if (next.hasValue) {
        streakAsync.whenData((streak) {
          WidgetSyncService.syncDailyContent(
            content: next.value!,
            streakCount: streak,
          );
        });
      }
    });

    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: const AppNavigationBar(selectedIndex: 0),
      child: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dailyContentProvider),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Masthead
            Container(
              color: AppColors.paper,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'ZITATATLAS',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Taeglich ein Zitat, klar kuratiert.',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.inkLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/settings'),
                        icon: const Icon(Icons.settings_outlined),
                        color: AppColors.ink,
                        tooltip: 'Einstellungen',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(width: 40, height: 2, color: AppColors.red),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  dailyContent.when(
                    data: (content) {
                      return FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: content.when(
                            quote: (quote) => QuoteCard(
                              quote: quote,
                              onTap: () => _showQuotePreview(context, quote),
                            ),
                            fact: (fact) => FactBlock(
                              fact: fact,
                              onRelatedQuoteTap: fact.relatedQuoteIds.isNotEmpty
                                  ? () => context.push(
                                      '/detail/${fact.relatedQuoteIds.first}',
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => const _LoadingCard(),
                    error: (error, _) => _EmptyStateCard(
                      icon: Icons.error_outline_rounded,
                      title: 'Ladevorgang fehlgeschlagen',
                      body: '$error',
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _calendarExpanded = !_calendarExpanded;
                      });
                    },
                    child: streakAsync.when(
                      data: (streak) => StreakBadge(
                        days: streak,
                        expanded: _calendarExpanded,
                      ),
                      loading: () => const StreakBadge(days: 0),
                      error: (_, __) => const StreakBadge(days: 0),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: _calendarExpanded
                        ? const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: StreakCalendar(),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  _QuickAccessSection(
                    onArchiveTap: () => context.push('/archive'),
                    onFavoritesTap: () => context.push('/favorites'),
                    onThinkersTap: () => context.push('/thinkers'),
                    onQuizTap: () => context.push('/quiz'),
                    onGamesTap: () => context.push('/games'),
                    onOnboardingTap: () => context.push('/onboarding'),
                    onNotificationTestTap: () async {
                      final current = ref
                          .read(dailyContentProvider)
                          .valueOrNull;
                      if (current != null) {
                        final quote = current.when(
                          quote: (q) => q,
                          fact: (_) => null,
                        );
                        if (quote != null) {
                          await NotificationService.instance.showDailyQuote(
                            quote,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BroadsheetButton extends StatelessWidget {
  const _BroadsheetButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BroadsheetOutlineButton extends StatelessWidget {
  const _BroadsheetOutlineButton({
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection({
    required this.onArchiveTap,
    required this.onFavoritesTap,
    required this.onThinkersTap,
    required this.onQuizTap,
    required this.onGamesTap,
    required this.onOnboardingTap,
    required this.onNotificationTestTap,
  });

  final VoidCallback onArchiveTap;
  final VoidCallback onFavoritesTap;
  final VoidCallback onThinkersTap;
  final VoidCallback onQuizTap;
  final VoidCallback onGamesTap;
  final VoidCallback onOnboardingTap;
  final VoidCallback onNotificationTestTap;

  @override
  Widget build(BuildContext context) {
    const entries = <_QuickAccessEntry>[
      _QuickAccessEntry(
        title: 'Archiv',
        description: 'Ältere Zitate schnell finden',
        icon: Icons.library_books_outlined,
      ),
      _QuickAccessEntry(
        title: 'Favoriten',
        description: 'Gespeicherte Inhalte ansehen',
        icon: Icons.favorite_border_rounded,
      ),
      _QuickAccessEntry(
        title: 'Denker',
        description: 'Autorinnen und Autoren entdecken',
        icon: Icons.psychology_outlined,
      ),
      _QuickAccessEntry(
        title: 'Quiz',
        description: 'Wissen direkt testen',
        icon: Icons.quiz_outlined,
      ),
      _QuickAccessEntry(
        title: 'Minigames',
        description: 'Kurze spielerische Pausen',
        icon: Icons.sports_esports_outlined,
      ),
      _QuickAccessEntry(
        title: 'Einführung',
        description: 'App und Funktionen erkunden',
        icon: Icons.school_outlined,
      ),
    ];

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Text(
                  'SCHNELLZUGRIFF',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Text(
                'Links zu den wichtigsten Bereichen',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  color: AppColors.inkLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final tileWidth = (constraints.maxWidth - 12) / 2;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _QuickAccessTile(
                    width: tileWidth,
                    entry: entries[0],
                    onTap: onArchiveTap,
                  ),
                  _QuickAccessTile(
                    width: tileWidth,
                    entry: entries[1],
                    onTap: onFavoritesTap,
                  ),
                  _QuickAccessTile(
                    width: tileWidth,
                    entry: entries[2],
                    onTap: onThinkersTap,
                  ),
                  _QuickAccessTile(
                    width: tileWidth,
                    entry: entries[3],
                    onTap: onQuizTap,
                  ),
                  _QuickAccessTile(
                    width: tileWidth,
                    entry: entries[4],
                    onTap: onGamesTap,
                  ),
                  _QuickAccessTile(
                    width: tileWidth,
                    entry: entries[5],
                    onTap: onOnboardingTap,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _BroadsheetOutlineButton(
            onPressed: onNotificationTestTap,
            label: 'BENACHRICHTIGUNG TESTEN',
          ),
        ],
      ),
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({
    required this.width,
    required this.entry,
    required this.onTap,
  });

  final double width;
  final _QuickAccessEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paperDark,
          border: Border.all(color: AppColors.rule, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(entry.icon, color: AppColors.red, size: 20),
                  const SizedBox(height: 12),
                  Text(
                    entry.title,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.description,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      height: 1.3,
                      color: AppColors.inkLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessEntry {
  const _QuickAccessEntry({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

extension on _HomeScreenState {
  Future<void> _showQuotePreview(BuildContext context, Quote quote) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
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
                const SizedBox(height: 16),
                Text(
                  'VORSCHAU',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                AdaptiveQuoteText(
                  text: quote.textDe,
                  minFontSize: 24,
                  maxFontSize: 34,
                  maxLines: 8,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '— ${quote.source} · ${quote.year}',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: AppColors.inkLight,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _BroadsheetOutlineButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          context.push('/detail/${quote.id}');
                        },
                        label: 'DETAIL',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BroadsheetButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          ShareCardRenderer().shareQuote(quote, context);
                        },
                        label: 'TEILEN',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(
          left: BorderSide(color: AppColors.ink, width: 1),
          right: BorderSide(color: AppColors.ink, width: 1),
          bottom: BorderSide(color: AppColors.ink, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.red),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
        ),
      ),
    );
  }
}
