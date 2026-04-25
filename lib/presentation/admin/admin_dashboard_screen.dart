import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/daily_content.dart';
import '../../domain/providers/admin_access_provider.dart';
import '../../domain/providers/app_mode_provider.dart';
import '../../domain/providers/daily_content_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(adminAccessProvider);
    if (!isAdmin) {
      return AppDecoratedScaffold(
        appBar: null,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Admin-Bereich ist gesperrt.',
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      );
    }

    final appMode = ref.watch(appModeNotifierProvider);
    final dailyContentAsync = ref.watch(dailyContentProvider);

    return AppDecoratedScaffold(
      appBar: null,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: <Widget>[
          Text(
            'ADMIN DASHBOARD',
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),
          Container(width: 40, height: 2, color: AppColors.red),
          const SizedBox(height: 16),
          _Panel(
            title: 'AKTUELLER MODUS',
            child: Text(
              _modeLabel(appMode),
              style: GoogleFonts.ibmPlexSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: 'MODUS SCHNELLWECHSEL',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppMode.values
                  .map(
                    (mode) => _ModeButton(
                      selected: mode == appMode,
                      label: _modeLabel(mode),
                      onTap: () async {
                        await ref
                            .read(appModeNotifierProvider.notifier)
                            .set(mode);
                        ref.invalidate(dailyContentProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Modus gewechselt: ${_modeLabel(mode)}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: 'HEUTIGER CONTENT STATUS',
            child: dailyContentAsync.when(
              data: (content) {
                return Text(
                  content.when(
                    quote: (quote) => 'Zitat: ${quote.source} (${quote.year})',
                    fact: (fact) => 'Fakt: ${fact.headline}',
                    thinkerQuote: (quote) => 'Denker: ${quote.author}',
                  ),
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    color: AppColors.ink,
                    height: 1.4,
                  ),
                );
              },
              loading: () =>
                  const LinearProgressIndicator(color: AppColors.red),
              error: (error, _) => Text(
                'Fehler: $error',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  color: AppColors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: 'AKTIONEN',
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _ActionButton(
                    label: 'NEU LADEN',
                    onTap: () {
                      ref.invalidate(dailyContentProvider);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    label: 'ZUR STARTSEITE',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _modeLabel(AppMode mode) {
  switch (mode) {
    case AppMode.public:
      return 'Für alle';
    case AppMode.adminMarx:
      return 'Marx-Modus';
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.red,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.red : AppColors.paperDark,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.redOnRed : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.paper,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
