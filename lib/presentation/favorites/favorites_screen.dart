import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/pdf_export_service.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/providers/favorites_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/quote_card.dart';
import '../loading/app_loading_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

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
                favoritesAsync.when(
                  data: (quotes) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'FAVORITEN',
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
                            '${quotes.length} Einträge',
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
                  loading: () => Text(
                    'FAVORITEN',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  error: (_, __) => Text(
                    'FAVORITEN',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: favoritesAsync.maybeWhen(
                      data: (quotes) => () async {
                        final service = PdfExportService();
                        await service.exportFavorites(
                          quotes: quotes,
                          facts: const [],
                        );
                      },
                      orElse: () => null,
                    ),
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                    label: Text(
                      'PDF',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(foregroundColor: AppColors.red),
                  ),
                ),
                const SizedBox(height: 12),
                Container(width: 40, height: 2, color: AppColors.red),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: const SizedBox.shrink(),
          ),
          Expanded(
            child: favoritesAsync.when(
              data: (quotes) {
                if (quotes.isEmpty) {
                  return _FavoritesEmptyStateCard(
                    onGoArchive: () => context.push('/archive'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    final quote = quotes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: QuoteCard(
                        quote: quote,
                        onTap: () => context.push(
                          '/detail/${Uri.encodeComponent(quote.id)}',
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const AppInlineLoadingState(
                title: 'Favoriten werden geladen',
                subtitle: 'Gespeicherte Zitate werden zusammengestellt ...',
              ),
              error: (error, _) => AppInlineErrorState(
                title: 'Favoriten konnten nicht geladen werden',
                message: 'Fehler: $error',
                onRetry: () => ref.invalidate(favoritesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Favorites intro/tip card removed per scope-reduction request.

class _FavoritesEmptyStateCard extends StatelessWidget {
  const _FavoritesEmptyStateCard({required this.onGoArchive});

  final VoidCallback onGoArchive;

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
                'Noch keine Favoriten',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Markiere ein Zitat mit dem Herzsymbol. Danach erscheint es hier und kann als PDF exportiert werden.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onGoArchive,
                  child: const Text('ZUM ARCHIV'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
