import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/notification_service.dart';
import '../../core/services/widget_sync_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/daily_content.dart';
import '../../domain/providers/app_mode_provider.dart';
import '../../domain/providers/daily_content_provider.dart';
import '../../domain/providers/streak_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
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

  void _showModeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => _ModeDialog(
        currentMode: ref.read(appModeNotifierProvider),
        onModeSelected: (mode) async {
          await ref.read(appModeNotifierProvider.notifier).set(mode);
          // Invalidate daily content so the home screen refreshes
          ref.invalidate(dailyContentProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyContent = ref.watch(dailyContentProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final mode = ref.watch(appModeNotifierProvider);

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
                        child: Text(
                          'DAS KAPITAL',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
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
                            border: Border.all(color: AppColors.ink, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                _modeLabelShort(mode),
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.unfold_more,
                                size: 12,
                                color: AppColors.ink,
                              ),
                            ],
                          ),
                        ),
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
                  // Navigation buttons row 1
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _BroadsheetButton(
                          onPressed: () => context.push('/archive'),
                          label: 'ARCHIV',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BroadsheetButton(
                          onPressed: () => context.push('/favorites'),
                          label: 'FAVORITEN',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Navigation buttons row 2
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _BroadsheetButton(
                          onPressed: () => context.push('/thinkers'),
                          label: 'DENKER',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BroadsheetButton(
                          onPressed: () => context.push('/quiz'),
                          label: 'QUIZ',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _BroadsheetButton(
                    onPressed: () => context.push('/onboarding'),
                    label: 'EINFÜHRUNG',
                    fullWidth: true,
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
                        );
                        if (quote != null) {
                          await NotificationService.instance.showDailyQuote(
                            quote,
                          );
                        }
                      }
                    },
                    label: 'BENACHRICHTIGUNG TESTEN',
                  ),
                ],
              ),
            ),
          ],
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
    }
  }
}

class _ModeDialog extends StatelessWidget {
  const _ModeDialog({
    required this.currentMode,
    required this.onModeSelected,
  });

  final AppMode currentMode;
  final void Function(AppMode) onModeSelected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.paper,
      title: Text(
        'AUSGABE WÄHLEN',
        style: GoogleFonts.ibmPlexSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.red,
          letterSpacing: 1.5,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppMode.values.expand<Widget>((AppMode mode) {
              final isLast = mode == AppMode.values.last;
              return <Widget>[
                _ModeOption(
                  mode: mode,
                  selected: mode == currentMode,
                  title: _getModeTitle(mode),
                  subtitle: _getModeSubtitle(mode),
                  onTap: () {
                    onModeSelected(mode);
                    Navigator.of(context).pop();
                  },
                ),
                if (!isLast)
                  Container(
                    height: 1,
                    color: AppColors.ink,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                  ),
              ];
            }).toList(),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }

  String _getModeTitle(AppMode mode) {
    switch (mode) {
      case AppMode.marx:
        return 'Marx & Engels';
      case AppMode.history:
        return 'Weltgeschichte';
      case AppMode.mixed:
        return 'Gemischt';
    }
  }

  String _getModeSubtitle(AppMode mode) {
    switch (mode) {
      case AppMode.marx:
        return 'Zitate aus den Originalwerken';
      case AppMode.history:
        return 'Kuratierte Fakten & Ereignisse';
      case AppMode.mixed:
        return 'Täglich abwechselnd';
    }
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.mode,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final AppMode mode;
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 3),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ink, width: 1.5),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.red,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w400,
                      color: AppColors.ink,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ink.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
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
  const _BroadsheetButton({
    required this.onPressed,
    required this.label,
    this.fullWidth = false,
  });

  final VoidCallback onPressed;
  final String label;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ink,
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
                color: AppColors.paper,
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

