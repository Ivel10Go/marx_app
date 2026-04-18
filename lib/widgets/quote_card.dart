import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../data/models/quote.dart';
import 'category_chip.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({required this.quote, this.trailing, this.onTap, super.key});

  final Quote quote;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Kicker-Band (rot)
        Container(
          color: AppColors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${quote.source.toUpperCase()} · ${quote.year}',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.redOnRed,
                  letterSpacing: 1.8,
                ),
              ),
              Text(
                quote.chapter,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 8,
                  color: AppColors.redOnRed.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        // Hauptkarte
        Container(
          decoration: const BoxDecoration(
            color: AppColors.paper,
            border: Border(
              left: BorderSide(color: AppColors.ink, width: 1),
              right: BorderSide(color: AppColors.ink, width: 1),
              bottom: BorderSide(color: AppColors.ink, width: 1),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Zitat-Text
                    Text(
                      quote.textDe,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 14),
                    // Rote Linie
                    Container(width: 28, height: 2, color: AppColors.red),
                    const SizedBox(height: 10),
                    // Attribution
                    Text(
                      '— ${quote.source}',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 11,
                        color: AppColors.inkLight,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: quote.category
                          .take(3)
                          .map((String item) => CategoryChip(label: item))
                          .toList(),
                    ),
                    if (trailing != null) ...<Widget>[
                      const SizedBox(height: 12),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
