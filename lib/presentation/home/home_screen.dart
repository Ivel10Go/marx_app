import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/widget_sync_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/share_card_renderer.dart';
import '../../data/models/daily_content.dart';
import '../../data/models/quote.dart';
import '../../data/models/thinker_quote.dart';
import '../../domain/providers/admin_access_provider.dart';
import '../../domain/providers/daily_content_provider.dart';
import '../../domain/providers/app_mode_provider.dart';
import '../../domain/providers/streak_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/adaptive_quote_text.dart';
import '../../widgets/quote_card.dart';
import '../../widgets/streak_badge.dart';
import '../home/dialogs/mode_dialog.dart';
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
      if (mounted) {
        ref.read(streakControllerProvider.notifier).logTodayAndRefresh();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setMode(AppMode mode) async {
    await ref.read(appModeNotifierProvider.notifier).set(mode);
    ref.invalidate(dailyContentProvider);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modus gewechselt: ${_modeLabel(mode)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _modeLabel(AppMode mode) {
    switch (mode) {
      case AppMode.public:
        return 'Für alle';
      case AppMode.adminMarx:
        return 'Marx-Modus';
    }
  }

  Future<void> _showModeDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ModeDialog(onModeSelected: _setMode);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dailyContent = ref.watch(dailyContentProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final appMode = ref.watch(appModeNotifierProvider);
    final isAdmin = ref.watch(adminAccessProvider);
    // Sync widget whenever daily content and streak are available
    ref.listen(dailyContentProvider, (_, next) {
      if (next.hasValue) {
        streakAsync.whenData((streak) {
          WidgetSyncService.syncDailyContent(
            content: next.value!,
            streakCount: streak,
            modeLabel: appMode.name.toUpperCase(),
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
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: <Widget>[
            Container(
              color: scheme.surface,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('ZITATATLAS', style: AppTheme.masthead),
                            const SizedBox(height: 4),
                            Text(
                              _mastheadSubtitle(),
                              style: AppTheme.mastHeadSubtitle,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/settings'),
                        icon: const Icon(Icons.settings_outlined),
                        color: scheme.onSurface,
                        tooltip: 'Einstellungen',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(width: 40, height: 2, color: AppColors.red),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: isAdmin
                            ? _BroadsheetOutlineButton(
                                onPressed: _showModeDialog,
                                label: _modeLabel(appMode),
                              )
                            : Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.zero,
                                  onTap: () => context.push('/settings'),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: scheme.outline,
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          'PERSONALISIERT',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.ibmPlexSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: scheme.onSurface,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.chevron_right_rounded,
                                          size: 16,
                                          color: AppColors.inkMuted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (isAdmin) ...<Widget>[
                        const SizedBox(width: 10),
                        _BroadsheetButton(
                          onPressed: () => context.push('/admin'),
                          label: 'ADMIN',
                        ),
                      ],
                    ],
                  ),
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
                              onShare: () => ShareCardRenderer().shareQuote(
                                quote,
                                context,
                              ),
                              onTap: () =>
                                  _showQuoteInsightSheet(context, quote),
                              onLongPress: () =>
                                  _showQuoteInsightSheet(context, quote),
                            ),
                            fact: (fact) => FactBlock(
                              fact: fact,
                              onShareTap: () =>
                                  ShareCardRenderer().shareFact(fact, context),
                              onRelatedQuoteTap: fact.relatedQuoteIds.isNotEmpty
                                  ? () => context.push(
                                      '/detail/${fact.relatedQuoteIds.first}',
                                    )
                                  : null,
                            ),
                            thinkerQuote: (ThinkerQuote quote) =>
                                _ThinkerQuoteCard(quote: quote),
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
                  streakAsync.when(
                    data: (streak) => StreakBadge(
                      days: streak,
                      expanded: _calendarExpanded,
                      onTap: () {
                        setState(() {
                          _calendarExpanded = !_calendarExpanded;
                        });
                      },
                    ),
                    loading: () => const StreakBadge(days: 0),
                    error: (_, __) => const StreakBadge(days: 0),
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
                    onAdminTap: isAdmin ? () => context.push('/admin') : null,
                    onOrientationTap: () =>
                        context.push('/political-orientation'),
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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline, width: 1),
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
                color: scheme.onSurface,
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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection({
    required this.onAdminTap,
    required this.onOrientationTap,
  });

  final VoidCallback? onAdminTap;
  final VoidCallback onOrientationTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Text(
                  'AKTIONEN',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Text(
                'Heute im Fokus',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _BroadsheetOutlineButton(
                  onPressed: onOrientationTap,
                  label: 'WISCHTEST',
                ),
              ),
              const SizedBox(width: 10),
              if (onAdminTap != null) ...<Widget>[
                _BroadsheetButton(onPressed: onAdminTap!, label: 'ADMIN'),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ThinkerQuoteCard extends StatelessWidget {
  const _ThinkerQuoteCard({required this.quote});

  final ThinkerQuote quote;

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.paperDark,
                    border: Border.all(color: AppColors.rule, width: 1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        quote.author.toUpperCase(),
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${quote.source} · ${quote.year}',
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
            const SizedBox(height: 16),
            AdaptiveQuoteText(
              text: quote.textDe,
              minFontSize: 22,
              maxFontSize: 30,
              maxLines: 7,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Container(width: 28, height: 2, color: AppColors.red),
          ],
        ),
      ),
    );
  }
}

extension on _HomeScreenState {
  Future<void> _showQuoteInsightSheet(BuildContext context, Quote quote) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(width: 44, height: 2, color: AppColors.red),
                  const SizedBox(height: 14),
                  Text(
                    'VOLLTEXT',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    quote.textDe,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: AppColors.ink,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'ERKLAERUNG',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    quote.explanationShort,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      color: AppColors.ink,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'KONTEXT',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quote.explanationLong,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      color: AppColors.ink,
                      height: 1.6,
                    ),
                  ),
                  if (quote.funFact != null &&
                      quote.funFact!.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 14),
                    Text(
                      'HINWEIS',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quote.funFact!,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: AppColors.inkLight,
                        height: 1.6,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _BroadsheetOutlineButton(
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            ShareCardRenderer().shareQuote(quote, context);
                          },
                          label: 'TEILEN',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BroadsheetButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          label: 'SCHLIESSEN',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 10, width: 120, color: AppColors.paperDark),
            const SizedBox(height: 16),
            Container(
              height: 18,
              width: double.infinity,
              color: AppColors.paperDark,
            ),
            const SizedBox(height: 8),
            Container(height: 18, width: 240, color: AppColors.paperDark),
            const SizedBox(height: 12),
            Container(width: 28, height: 2, color: AppColors.red),
            const SizedBox(height: 14),
            Container(height: 12, width: 140, color: AppColors.paperDark),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: const <Widget>[
                _SkeletonChip(),
                _SkeletonChip(),
                _SkeletonChip(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonChip extends StatelessWidget {
  const _SkeletonChip();

  @override
  Widget build(BuildContext context) {
    return Container(width: 56, height: 20, color: AppColors.paperDark);
  }
}

String _mastheadSubtitle() {
  final now = DateTime.now();
  final monthNames = <String>[
    'Januar',
    'Februar',
    'Maerz',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];
  final issueNumber = now.difference(DateTime(2000, 1, 1)).inDays;
  return '${now.day}. ${monthNames[now.month - 1]} ${now.year} · Ausgabe $issueNumber';
}
