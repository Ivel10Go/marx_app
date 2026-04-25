import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/providers/daily_quote_provider.dart';
import '../../domain/providers/settings_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/quote_card.dart';
import '../../widgets/streak_badge.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyQuote = ref.watch(dailyQuoteProvider);
    final settings = ref.watch(settingsControllerProvider);

    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: const AppNavigationBar(selectedIndex: 0),
      child: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dailyQuoteProvider),
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
                  Text(
                    'ZITATATLAS',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  dailyQuote.when(
                    data: (quote) {
                      if (quote == null) {
                        return const _EmptyStateCard(
                          icon: Icons.hourglass_empty_rounded,
                          title: 'Noch kein Tageszitat',
                          body:
                              'Die App lädt den Korpus und bereitet das erste Zitat vor.',
                        );
                      }

                      return FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: QuoteCard(
                            quote: quote,
                            onTap: () => context.push('/detail/${quote.id}'),
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
                  settings.maybeWhen(
                    data: (value) => StreakBadge(days: value.streak),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  _BroadsheetButton(
                    onPressed: () async => ref.invalidate(dailyQuoteProvider),
                    label: 'NEUE AUSGABE',
                  ),
                  const SizedBox(height: 12),
                  _BroadsheetOutlineButton(
                    onPressed: () async {
                      final current = ref.read(dailyQuoteProvider).valueOrNull;
                      if (current != null) {
                        await NotificationService.instance.showDailyQuote(
                          current,
                        );
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
}

class _BroadsheetButton extends StatelessWidget {
  const _BroadsheetButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

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
