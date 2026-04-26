import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/share_card_renderer.dart';
import '../../data/models/quote.dart';
import '../../domain/providers/daily_quote_provider.dart';
import '../../domain/providers/favorites_provider.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/providers/tts_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/category_chip.dart';

class QuoteDetailScreen extends ConsumerWidget {
  const QuoteDetailScreen({required this.quoteId, super.key});

  final String quoteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(quoteByIdProvider(quoteId));
    final favoriteAsync = ref.watch(isFavoriteProvider(quoteId));
    final ttsState = ref.watch(ttsStateProvider);

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
                SizedBox(
                  width: 56,
                  child: Material(
                    color: ttsState == quote.id
                        ? AppColors.red
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () => ref
                          .read(ttsStateProvider.notifier)
                          .toggleQuote(quote.id, quote),
                      child: Center(
                        child: Icon(
                          ttsState == quote.id
                              ? Icons.stop_rounded
                              : Icons.volume_up_outlined,
                          color: ttsState == quote.id
                              ? AppColors.redOnRed
                              : AppColors.ink,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
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
            key: ValueKey('quote-detail-${quote.id}'),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Quote text
                    Text(
                      quote.textDe,
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
                    const SizedBox(height: 14),
                    favoriteAsync.when(
                      data: (isFavorite) => _FavoriteButton(
                        isFavorite: isFavorite,
                        onTap: () async {
                          final repo = ref.read(quoteRepositoryProvider);
                          if (isFavorite) {
                            await repo.removeFavorite(quoteId);
                          } else {
                            await repo.addFavorite(quoteId);
                          }
                        },
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
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
                    _SectionCard(
                      title: 'AUSFUEHRLICHE ERKLAERUNG',
                      body: quote.explanationLong,
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

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Material(
        color: isFavorite ? AppColors.red : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  isFavorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 18,
                  color: isFavorite ? AppColors.redOnRed : AppColors.ink,
                ),
                const SizedBox(width: 8),
                Text(
                  'MERKEN',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isFavorite ? AppColors.redOnRed : AppColors.ink,
                    letterSpacing: 1.0,
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
