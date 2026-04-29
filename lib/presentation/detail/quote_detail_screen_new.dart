import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/purchases_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/share_card_renderer.dart';
import '../../core/utils/image_loader.dart';
import '../../data/models/quote.dart';
import '../../domain/providers/daily_quote_provider.dart';
import '../../domain/providers/favorites_provider.dart';
import '../../domain/providers/repository_providers.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/adaptive_quote_text.dart';
import '../../widgets/category_chip.dart';

class QuoteDetailScreen extends ConsumerStatefulWidget {
  const QuoteDetailScreen({required this.quoteId, super.key});

  final String quoteId;

  @override
  ConsumerState<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends ConsumerState<QuoteDetailScreen> {
  late final ScrollController _scrollController;
  String? _lastOpenedQuoteId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(keepScrollOffset: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final quoteId = widget.quoteId;
    if (_lastOpenedQuoteId != quoteId) {
      _lastOpenedQuoteId = quoteId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) {
          return;
        }
        _scrollController.jumpTo(0);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quoteId = widget.quoteId;
    final quoteAsync = ref.watch(quoteByIdProvider(quoteId));
    final favoriteAsync = ref.watch(isFavoriteProvider(quoteId));
    final isPro = ref.watch(isProProvider);

    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: quoteAsync.when(
        data: (quote) {
          if (quote == null) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _BroadsheetOutlineButton(
                    onPressed: () async {
                      await ShareCardRenderer().shareQuote(quote, context);
                    },
                    label: 'TEILEN',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BroadsheetButton(
                    onPressed: () => _showSimpleExplanation(context, quote),
                    label: 'ERKLAERUNG',
                  ),
                ),
                const SizedBox(width: 12),
                favoriteAsync.when(
                  data: (isFavorite) {
                    return SizedBox(
                      width: 48,
                      child: Material(
                        color: isFavorite ? AppColors.red : Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final repo = ref.read(quoteRepositoryProvider);
                            if (isFavorite) {
                              await repo.removeFavorite(quoteId);
                            } else {
                              await repo.addFavorite(quoteId);
                            }
                          },
                          child: Center(
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? AppColors.redOnRed
                                  : AppColors.ink,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
      child: quoteAsync.when(
        data: (quote) {
          if (quote == null) {
            return const Center(child: Text('Zitat nicht gefunden.'));
          }

          return ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Masthead
              Container(
                color: AppColors.red,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${quote.source.toUpperCase()} · ${quote.year}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.redOnRed,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      quote.chapter,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 9,
                        color: AppColors.redOnRed.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // Featured image if available
              if (quote.imageUrl != null && quote.imageUrl!.isNotEmpty)
                CachedImageLoader(
                  imageUrl: quote.imageUrl!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  cacheConfig: const ImageCacheConfig(
                    cacheDurationDays: 7,
                    maxMemoryCacheSizeMB: 50,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Quote text
                    AdaptiveQuoteText(
                      text: quote.textDe,
                      minFontSize: 28,
                      maxFontSize: 42,
                      maxLines: 9,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 14),
                    Container(width: 28, height: 2, color: AppColors.red),
                    const SizedBox(height: 14),
                    Text(
                      '— ${quote.source}',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 12,
                        color: AppColors.inkLight,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: quote.category
                          .map((String item) => CategoryChip(label: item))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    // Section
                    _SectionCard(
                      title: 'KURZERKLAERUNG',
                      body: quote.explanationShort,
                    ),
                    const SizedBox(height: 16),
                    if (isPro)
                      _SectionCard(
                        title: 'AUSFUEHRLICHE ERKLAERUNG',
                        body: quote.explanationLong,
                      )
                    else
                      _PremiumLockedSection(
                        title: 'AUSFUEHRLICHE ERKLAERUNG',
                        teaser:
                            'Die tiefe Analyse ist Teil von Zitate App Pro.',
                        onUnlockTap: () => context.push('/premium-features'),
                      ),
                    const SizedBox(height: 16),
                    if (isPro)
                      _SectionCard(
                        title: 'LERNSEITE',
                        body:
                            'Serie: ${quote.series}\n\nDiese Serie verbindet thematisch verwandte Zitate zu einem Lernpfad.',
                      )
                    else
                      _PremiumLockedSection(
                        title: 'LERNSEITE',
                        teaser:
                            'Kuratierte Lernserien mit roten Faden sind Teil von Zitate App Pro.',
                        onUnlockTap: () => context.push('/premium-features'),
                      ),
                    if (quote.funFact != null) ...<Widget>[
                      const SizedBox(height: 16),
                      _SectionCard(title: 'KONTEXT', body: quote.funFact!),
                    ],
                    if (quote.relatedIds.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'VERWANDTE ZITATE',
                        body: quote.relatedIds.join(' · '),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Fehler: $error')),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.body});

  final String title;
  final String body;

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
            const SizedBox(height: 10),
            Text(
              body,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                color: AppColors.ink,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumLockedSection extends StatelessWidget {
  const _PremiumLockedSection({
    required this.title,
    required this.teaser,
    required this.onUnlockTap,
  });

  final String title;
  final String teaser;
  final VoidCallback onUnlockTap;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '$title · PRO',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const Icon(Icons.lock_outline_rounded, size: 16),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              teaser,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                color: AppColors.inkLight,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            _BroadsheetButton(
              onPressed: onUnlockTap,
              label: 'PRO FREISCHALTEN',
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.paper,
                letterSpacing: 1.0,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showSimpleExplanation(BuildContext context, Quote quote) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.paper,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'EINFACHER ERKLAERT',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: 12),
            Container(width: 20, height: 2, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              quote.explanationShort,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                color: AppColors.ink,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
