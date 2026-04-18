import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/providers/archive_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/quote_card.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveAsync = ref.watch(archiveProvider);

    return AppDecoratedScaffold(
      appBar: null,
      bottomNavigationBar: const AppNavigationBar(selectedIndex: 1),
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
                  'ARCHIV',
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
          Expanded(
            child: archiveAsync.when(
              data: (quotes) {
                if (quotes.isEmpty) {
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
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    final quote = quotes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: QuoteCard(
                        quote: quote,
                        onTap: () => context.push('/detail/${quote.id}'),
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
