import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/daily_content.dart';
import '../../../domain/providers/app_mode_provider.dart';

class ModeSelector extends ConsumerWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final mode = ref.watch(appModeNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Label
        Text(
          'TÄGLICHER INHALT',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: scheme.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),

        // Options
        ..._buildOptions(context, ref, mode, scheme),

        // Hint text
        const SizedBox(height: 16),
        Text(
          'Gilt ab der nächsten Ausgabe',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: scheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildOptions(
    BuildContext context,
    WidgetRef ref,
    AppMode mode,
    ColorScheme scheme,
  ) {
    final options = <Widget>[];

    for (int i = 0; i < AppMode.values.length; i++) {
      final appMode = AppMode.values[i];
      final isLast = i == AppMode.values.length - 1;

      options.add(
        _ModeOptionTile(
          mode: appMode,
          selected: mode == appMode,
          title: _getModeTitle(appMode),
          subtitle: _getModeSubtitle(appMode),
          scheme: scheme,
          onTap: () => ref.read(appModeNotifierProvider.notifier).set(appMode),
        ),
      );

      if (!isLast) {
        options.add(
          Container(
            height: 1,
            color: scheme.outline,
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),
        );
      }
    }

    return options;
  }

  String _getModeTitle(AppMode mode) {
    switch (mode) {
      case AppMode.public:
        return 'Für alle';
      case AppMode.adminMarx:
        return 'Marx-Modus';
    }
  }

  String _getModeSubtitle(AppMode mode) {
    switch (mode) {
      case AppMode.public:
        return 'Personalisierte Tageszitate';
      case AppMode.adminMarx:
        return 'Nur für interne Admin-Nutzung';
    }
  }
}

class _ModeOptionTile extends StatelessWidget {
  final AppMode mode;
  final bool selected;
  final String title;
  final String subtitle;
  final ColorScheme scheme;
  final VoidCallback onTap;

  const _ModeOptionTile({
    required this.mode,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 2),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: scheme.outline,
                    width: selected ? 2 : 1.5,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scheme.primary,
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
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: scheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: scheme.onSurfaceVariant,
                      height: 1.3,
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
