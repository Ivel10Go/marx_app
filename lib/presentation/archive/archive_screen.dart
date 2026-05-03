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
import '../loading/app_loading_screen.dart';
import 'widgets/archive_filter_chips.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  bool _filtersExpanded = false;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final archiveAsync = ref.watch(archiveProvider);
    final scheme = Theme.of(context).colorScheme;
    final selectedTab = ref.watch(archiveTabProvider);
    final selectedTheme = ref.watch(archiveThemeFilterProvider);
    final selectedOrientation = ref.watch(archiveOrientationFilterProvider);
    final query = ref.watch(archiveQueryProvider);

    void setTab(ArchiveTab tab) {
      ref.read(archiveTabProvider.notifier).state = tab;
      ref.read(archiveThemeFilterProvider.notifier).state = null;
      ref.read(archiveOrientationFilterProvider.notifier).state = null;
      setState(() {
        _filtersExpanded = false;
      });
    }

    void clearFilters() {
      ref.read(archiveThemeFilterProvider.notifier).state = null;
      ref.read(archiveOrientationFilterProvider.notifier).state = null;
    }

    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(
                bottom: BorderSide(color: scheme.outline, width: 1),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: archiveAsync.when(
                        data: (_) => Text(
                          'ARCHIV',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                        loading: () => Text(
                          'ARCHIV',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                        error: (_, __) => Text(
                          'ARCHIV',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        archiveAsync.when(
                          data: (items) => Text(
                            '${items.length} Einträge',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          loading: () => Text(
                            'Wird geladen',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          error: (_, __) => Text(
                            'Nicht verfügbar',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(width: 32, height: 2, color: AppColors.red),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Suche, filtere und springe zwischen Themen, Interessen und Geschichte.',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    border: Border.all(color: scheme.outline, width: 1),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _ArchiveTabButton(
                          label: 'ALLE',
                          active: selectedTab == ArchiveTab.all,
                          onTap: () => setTab(ArchiveTab.all),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ArchiveTabButton(
                          label: 'GESCHICHTE',
                          active: selectedTab == ArchiveTab.history,
                          onTap: () => setTab(ArchiveTab.history),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'SUCHE',
                    hintText: 'Begriffe, Personen, Quellen',
                    labelStyle: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: scheme.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(Icons.search, color: scheme.onSurface),
                    suffixIcon: query.trim().isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              ref.read(archiveQueryProvider.notifier).state =
                                  '';
                            },
                            icon: const Icon(Icons.clear),
                            tooltip: 'Suche löschen',
                          )
                        : null,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    color: scheme.onSurface,
                  ),
                  onChanged: (value) {
                    ref.read(archiveQueryProvider.notifier).state = value;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        selectedTheme == null && selectedOrientation == null
                            ? 'Filter einklappen, wenn du nur stöbern willst.'
                            : [
                                if (selectedTheme != null)
                                  'Thema: $selectedTheme',
                                if (selectedOrientation != null)
                                  'Orientierung: $selectedOrientation',
                              ].join(' · '),
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _filtersExpanded = !_filtersExpanded;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: const BorderSide(color: AppColors.ink, width: 1),
                      ),
                      icon: Icon(
                        _filtersExpanded ? Icons.expand_less : Icons.tune,
                        size: 16,
                      ),
                      label: Text(
                        _filtersExpanded ? 'FILTER SCHLIESSEN' : 'FILTER',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_filtersExpanded) ...<Widget>[
                  const SizedBox(height: 10),
                  ArchiveFilterChips(
                    onClearFilters:
                        selectedTheme == null && selectedOrientation == null
                        ? null
                        : clearFilters,
                  ),
                ] else if (selectedTheme != null ||
                    selectedOrientation != null) ...<Widget>[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: clearFilters,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.ink,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      side: const BorderSide(color: AppColors.ink, width: 1),
                    ),
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(
                      'FILTER LÖSCHEN',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: archiveAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const _ArchiveEmptyStateCard(
                    title: 'Keine Treffer',
                    body:
                        'Probiere eine andere Suche oder entferne einzelne Filter, um wieder mehr Einträge zu sehen.',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: item.isQuote
                          ? QuoteCard(
                              quote: item.quote!,
                              onTap: () => context.push(
                                '/detail/${Uri.encodeComponent(item.quote!.id)}',
                              ),
                            )
                          : FactBlock(
                              fact: item.fact!,
                              onRelatedQuoteTap:
                                  item.fact!.relatedQuoteIds.isNotEmpty
                                  ? () => context.push(
                                      '/detail/${Uri.encodeComponent(item.fact!.relatedQuoteIds.first)}',
                                    )
                                  : null,
                            ),
                    );
                  },
                );
              },
              loading: () => const AppInlineLoadingState(
                title: 'Archiv wird geladen',
                subtitle: 'Einträge und Filter werden vorbereitet ...',
              ),
              error: (error, _) => AppInlineErrorState(
                title: 'Archiv konnte nicht geladen werden',
                message: 'Fehler: $error',
                onRetry: () => ref.invalidate(archiveProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Archive intro/tip card removed per scope-reduction request.

class _ArchiveEmptyStateCard extends StatelessWidget {
  const _ArchiveEmptyStateCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Container(
          width: 460,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border.all(color: scheme.outline, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: 34, height: 2, color: AppColors.red),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
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
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.ink : scheme.surface,
          border: Border.all(color: AppColors.ink, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1.0,
                color: active ? AppColors.paper : AppColors.inkMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
