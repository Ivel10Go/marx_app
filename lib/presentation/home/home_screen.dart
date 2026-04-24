import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/notification_service.dart';
import '../../core/services/widget_sync_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/godmode_colors.dart';
import '../../data/models/daily_content.dart';
import '../../domain/providers/app_mode_provider.dart';
import '../../domain/providers/daily_content_provider.dart';
import '../../domain/providers/streak_provider.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/godmode_quote_card.dart';
import '../../widgets/quote_card.dart';
import '../../widgets/skeleton_card.dart';
import '../../widgets/streak_badge.dart';
import '../../widgets/thinker_quote_card.dart';
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
      ref.read(streakControllerProvider.notifier).logTodayAndRefresh();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showModeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => ModeDialog(
        currentMode: ref.read(appModeNotifierProvider),
        onModeSelected: (mode) async {
          await ref.read(appModeNotifierProvider.notifier).set(mode);
          ref.invalidate(dailyContentProvider);
          _controller.reset();
          _controller.forward();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyContent = ref.watch(dailyContentProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final mode = ref.watch(appModeNotifierProvider);
    final isGodmode = mode == AppMode.godmode;

    // Sync widget whenever daily content and streak are available
    ref.listen(dailyContentProvider, (_, next) {
      if (next.hasValue) {
        streakAsync.whenData((streak) {
          WidgetSyncService.syncDailyContent(
            content: next.value!,
            streakCount: streak,
            modeBadge: isGodmode ? '☭ GODMODE' : null,
          );
        });
      }
    });

    final bgColor = isGodmode ? GodmodeColors.background : AppColors.paper;
    final headerBg = isGodmode ? GodmodeColors.surface : AppColors.paper;
    final inkColor = isGodmode ? GodmodeColors.text : AppColors.ink;
    final accentColor = isGodmode ? GodmodeColors.accent : AppColors.red;

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: 0,
        isGodmode: isGodmode,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: accentColor,
          onRefresh: () async {
            ref.invalidate(dailyContentProvider);
            _controller.reset();
            await _controller.forward().orCancel;
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Masthead
              Container(
                color: headerBg,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: isGodmode
                              ? _GodmodeMasthead()
                              : Text(
                                  'DAS KAPITAL',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: inkColor,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                        ),
                        // Mode selector button
                        GestureDetector(
                          onTap: () => _showModeDialog(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: accentColor, width: 1),
                              color: isGodmode
                                  ? GodmodeColors.card
                                  : Colors.transparent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  _modeLabelShort(mode),
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: accentColor,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.unfold_more,
                                  size: 12,
                                  color: accentColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Issue number + date
                    Text(
                      _issueLabel(),
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        color: isGodmode
                            ? GodmodeColors.textMuted
                            : AppColors.inkMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(width: 40, height: 2, color: accentColor),
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
                              quote: (quote) => isGodmode
                                  ? GodmodeQuoteCard(
                                      quote: quote,
                                      onTap: () =>
                                          context.push('/detail/${quote.id}'),
                                    )
                                  : QuoteCard(
                                      quote: quote,
                                      onTap: () =>
                                          context.push('/detail/${quote.id}'),
                                    ),
                              fact: (fact) => FactBlock(
                                fact: fact,
                                onRelatedQuoteTap:
                                    fact.relatedQuoteIds.isNotEmpty
                                    ? () => context.push(
                                        '/detail/${fact.relatedQuoteIds.first}',
                                      )
                                    : null,
                              ),
                              thinkerQuote: (tq) => ThinkerQuoteCard(
                                thinkerQuote: tq,
                              ),
                            ),
                          ),
                        );
                      },
                      loading: () => const SkeletonCard(),
                      error: (error, _) => _EmptyStateCard(
                        icon: Icons.error_outline_rounded,
                        title: 'Ladevorgang fehlgeschlagen',
                        body: '$error',
                        isGodmode: isGodmode,
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
                          isGodmode: isGodmode,
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
                    // 2×2 navigation grid
                    _NavGrid(isGodmode: isGodmode),
                    const SizedBox(height: 12),
                    // Refresh button
                    _RefreshButton(
                      isGodmode: isGodmode,
                      onPressed: () {
                        ref.invalidate(dailyContentProvider);
                        _controller.reset();
                        _controller.forward();
                      },
                    ),
                    const SizedBox(height: 12),
                    _BroadsheetOutlineButton(
                      onPressed: () async {
                        final current =
                            ref.read(dailyContentProvider).valueOrNull;
                        if (current != null) {
                          final quote = current.when(
                            quote: (q) => q,
                            fact: (_) => null,
                            thinkerQuote: (_) => null,
                          );
                          if (quote != null) {
                            await NotificationService.instance.showDailyQuote(
                              quote,
                            );
                          }
                        }
                      },
                      label: 'BENACHRICHTIGUNG TESTEN',
                      isGodmode: isGodmode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _modeLabelShort(AppMode mode) {
    switch (mode) {
      case AppMode.marx:
        return 'MARX';
      case AppMode.history:
        return 'GESCHICHTE';
      case AppMode.mixed:
        return 'GEMISCHT';
      case AppMode.godmode:
        return '☭ GODMODE';
    }
  }

  String _issueLabel() {
    final now = DateTime.now();
    final epoch = DateTime(2000, 1, 1);
    final issue = now.difference(epoch).inDays;
    final months = <String>[
      'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
      'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
    ];
    final formatted = '${now.day}. ${months[now.month - 1]} ${now.year}';
    return 'AUSGABE $issue · $formatted';
  }
}

// Godmode pulsing masthead
class _GodmodeMasthead extends StatefulWidget {
  @override
  State<_GodmodeMasthead> createState() => _GodmodeMastheadState();
}

class _GodmodeMastheadState extends State<_GodmodeMasthead>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _pulse, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Text(
          '☭ MARX GODMODE',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color.lerp(
              GodmodeColors.accent,
              Colors.white,
              _anim.value * 0.4,
            ),
            letterSpacing: 1.5,
            shadows: <Shadow>[
              Shadow(
                color: GodmodeColors.accent
                    .withValues(alpha: 0.3 + 0.5 * _anim.value),
                blurRadius: 8,
              ),
            ],
          ),
        );
      },
    );
  }
}

// 2×2 navigation grid
class _NavGrid extends StatelessWidget {
  const _NavGrid({required this.isGodmode});

  final bool isGodmode;

  @override
  Widget build(BuildContext context) {
    final tiles = <_NavTile>[
      _NavTile(
        icon: Icons.library_books_outlined,
        label: 'ARCHIV',
        path: '/archive',
      ),
      _NavTile(
        icon: Icons.favorite_border_rounded,
        label: 'FAVORITEN',
        path: '/favorites',
      ),
      _NavTile(
        icon: Icons.psychology_outlined,
        label: 'DENKER',
        path: '/thinkers',
      ),
      _NavTile(icon: Icons.quiz_outlined, label: 'QUIZ', path: '/quiz'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.8,
      physics: const NeverScrollableScrollPhysics(),
      children: tiles.map((tile) {
        return _NavGridButton(tile: tile, isGodmode: isGodmode);
      }).toList(),
    );
  }
}

class _NavTile {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.path,
  });
  final IconData icon;
  final String label;
  final String path;
}

class _NavGridButton extends StatelessWidget {
  const _NavGridButton({required this.tile, required this.isGodmode});

  final _NavTile tile;
  final bool isGodmode;

  @override
  Widget build(BuildContext context) {
    final bgColor = isGodmode ? GodmodeColors.card : AppColors.ink;
    final fgColor = isGodmode ? GodmodeColors.text : AppColors.paper;
    final borderColor = isGodmode ? GodmodeColors.accent : AppColors.ink;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(tile.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(tile.icon, size: 14, color: fgColor),
                const SizedBox(width: 6),
                Text(
                  tile.label,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: fgColor,
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

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.isGodmode, required this.onPressed});
  final bool isGodmode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bgColor = isGodmode ? GodmodeColors.accent : AppColors.red;
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.refresh_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'NEUE AUSGABE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

class _BroadsheetOutlineButton extends StatelessWidget {
  const _BroadsheetOutlineButton({
    required this.onPressed,
    required this.label,
    required this.isGodmode,
  });

  final VoidCallback onPressed;
  final String label;
  final bool isGodmode;

  @override
  Widget build(BuildContext context) {
    final borderColor = isGodmode ? GodmodeColors.accent : AppColors.ink;
    final textColor = isGodmode ? GodmodeColors.text : AppColors.ink;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
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
                color: textColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.isGodmode,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isGodmode;

  @override
  Widget build(BuildContext context) {
    final bgColor = isGodmode ? GodmodeColors.card : AppColors.paper;
    final textColor = isGodmode ? GodmodeColors.text : AppColors.ink;
    final borderColor = isGodmode ? GodmodeColors.accent : AppColors.ink;
    final accentColor = isGodmode ? GodmodeColors.accent : AppColors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          left: BorderSide(color: borderColor, width: 1),
          right: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: accentColor),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: isGodmode ? GodmodeColors.textMuted : AppColors.inkLight,
            ),
          ),
        ],
      ),
    );
  }
}

