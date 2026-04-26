import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/providers/archive_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/quote_card.dart';
import '../home/widgets/fact_block.dart';
import 'widgets/archive_filter_chips.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveAsync = ref.watch(archiveProvider);

    return AppDecoratedScaffold(
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
                archiveAsync.when(
                  data: (items) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'ARCHIV',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${items.length} Einträge',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () {
                    return Text(
                      'ARCHIV',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.5,
                      ),
                    );
                  },
                  error: (_, __) {
                    return Text(
                      'ARCHIV',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.5,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Container(width: 40, height: 2, color: AppColors.red),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: <Widget>[
                _ArchiveTabButton(
                  label: 'ALLE',
                  active: ref.watch(archiveTabProvider) == ArchiveTab.all,
                  onTap: () {
                    ref.read(archiveTabProvider.notifier).state =
                        ArchiveTab.all;
                    ref.read(archiveActiveFiltersProvider.notifier).state =
                        <String>{};
                  },
                ),
                const SizedBox(width: 16),
                _ArchiveTabButton(
                  label: 'MARX',
                  active: ref.watch(archiveTabProvider) == ArchiveTab.marx,
                  onTap: () {
                    ref.read(archiveTabProvider.notifier).state =
                        ArchiveTab.marx;
                    ref.read(archiveActiveFiltersProvider.notifier).state =
                        <String>{};
                  },
                ),
                const SizedBox(width: 16),
                _ArchiveTabButton(
                  label: 'GESCHICHTE',
                  active: ref.watch(archiveTabProvider) == ArchiveTab.history,
                  onTap: () {
                    ref.read(archiveTabProvider.notifier).state =
                        ArchiveTab.history;
                    ref.read(archiveActiveFiltersProvider.notifier).state =
                        <String>{};
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.paper,
                border: Border.all(color: AppColors.ink, width: 1),
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'SUCHE',
                  labelStyle: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.inkMuted,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.ink),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  color: AppColors.ink,
                ),
                onChanged: (value) {
                  ref.read(archiveQueryProvider.notifier).state = value;
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: ArchiveFilterChips(),
          ),
          Expanded(
            child: archiveAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'Keine Treffer. Probiere einen Werk- oder Begriffsfilter.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: item.isQuote
                          ? QuoteCard(
                              quote: item.quote!,
                              onTap: () =>
                                  context.push('/detail/${item.quote!.id}'),
                            )
                          : FactBlock(
                              fact: item.fact!,
                              onRelatedQuoteTap:
                                  item.fact!.relatedQuoteIds.isNotEmpty
                                  ? () => context.push(
                                      '/detail/${item.fact!.relatedQuoteIds.first}',
                                    )
                                  : null,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveTabButton extends StatelessWidget {
  const _ArchiveTabButton({
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
