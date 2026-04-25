import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/thinker_quote.dart';
import '../../domain/providers/thinkers_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';

class ThinkersScreen extends ConsumerWidget {
  const ThinkersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(thinkerTypeProvider);
    final selectedAuthor = ref.watch(selectedAuthorProvider);

    return PopScope(
      canPop: selectedAuthor == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && selectedAuthor != null) {
          ref.read(selectedAuthorProvider.notifier).state = null;
        }
      },
      child: AppDecoratedScaffold(
        appBar: null,
        bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
        child: Column(
          children: <Widget>[
            // Masthead
            Container(
              color: AppColors.paper,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'DENKER',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(width: 40, height: 2, color: AppColors.red),
                  const SizedBox(height: 16),
                  // Type toggle
                  Row(
                    children: <Widget>[
                      _TypeTabButton(
                        label: 'PHILOSOPHEN',
                        active: selectedType == ThinkerType.philosopher,
                        onTap: () {
                          ref.read(thinkerTypeProvider.notifier).state =
                              ThinkerType.philosopher;
                          ref.read(selectedAuthorProvider.notifier).state =
                              null;
                        },
                      ),
                      const SizedBox(width: 20),
                      _TypeTabButton(
                        label: 'POLITIKER',
                        active: selectedType == ThinkerType.politician,
                        onTap: () {
                          ref.read(thinkerTypeProvider.notifier).state =
                              ThinkerType.politician;
                          ref.read(selectedAuthorProvider.notifier).state =
                              null;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: selectedAuthor == null
                  ? _AuthorList(type: selectedType)
                  : _QuoteList(author: selectedAuthor),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeTabButton extends StatelessWidget {
  const _TypeTabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1.0,
                color: active ? AppColors.ink : AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 56,
              height: 2,
              color: active ? AppColors.red : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorList extends ConsumerWidget {
  const _AuthorList({required this.type});

  final ThinkerType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorsAsync = ref.watch(thinkerAuthorsProvider);

    return authorsAsync.when(
      data: (authors) {
        if (authors.isEmpty) {
          return Center(
            child: Text(
              'Keine Einträge gefunden.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          itemCount: authors.length,
          separatorBuilder: (_, __) =>
              Container(height: 1, color: AppColors.rule),
          itemBuilder: (context, index) {
            final author = authors[index];
            return InkWell(
              onTap: () {
                ref.read(selectedAuthorProvider.notifier).state = author;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            author,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type == ThinkerType.philosopher
                                ? 'Philosoph'
                                : 'Politiker',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: AppColors.inkMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.inkMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
        ),
      ),
      error: (error, _) => Center(child: Text('Fehler: $error')),
    );
  }
}

class _QuoteList extends ConsumerWidget {
  const _QuoteList({required this.author});

  final String author;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesAsync = ref.watch(thinkerQuotesProvider);

    return Column(
      children: <Widget>[
        // Back bar
        Container(
          color: AppColors.paperDark,
          child: InkWell(
            onTap: () => ref.read(selectedAuthorProvider.notifier).state = null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 20, 10),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.arrow_back, size: 18, color: AppColors.ink),
                  const SizedBox(width: 8),
                  Text(
                    'ZURÜCK',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.ink,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    author.toUpperCase(),
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: quotesAsync.when(
            data: (quotes) {
              if (quotes.isEmpty) {
                return const Center(child: Text('Keine Zitate gefunden.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ThinkerQuoteCard(quote: quotes[index]),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
              ),
            ),
            error: (error, _) => Center(child: Text('Fehler: $error')),
          ),
        ),
      ],
    );
  }
}

class _ThinkerQuoteCard extends StatelessWidget {
  const _ThinkerQuoteCard({required this.quote});

  final ThinkerQuote quote;

  @override
  Widget build(BuildContext context) {
    final yearLabel = quote.year < 0
        ? '${quote.year.abs()} v. Chr.'
        : '${quote.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Kicker
        Container(
          color: AppColors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                quote.source.toUpperCase(),
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.redOnRed,
                  letterSpacing: 1.8,
                ),
              ),
              Text(
                yearLabel,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 8,
                  color: AppColors.redOnRed.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        // Card body
        Container(
          decoration: const BoxDecoration(
            color: AppColors.paper,
            border: Border(
              left: BorderSide(color: AppColors.ink, width: 1),
              right: BorderSide(color: AppColors.ink, width: 1),
              bottom: BorderSide(color: AppColors.ink, width: 1),
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '»${quote.textDe}«',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                  height: 1.55,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Container(width: 24, height: 2, color: AppColors.red),
              const SizedBox(height: 8),
              Text(
                '— ${quote.author}',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
