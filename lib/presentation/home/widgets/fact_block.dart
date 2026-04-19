import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/history_fact.dart';
import '../../../widgets/category_chip.dart';

class FactBlock extends StatelessWidget {
  const FactBlock({required this.fact, this.onRelatedQuoteTap, super.key});

  final HistoryFact fact;
  final VoidCallback? onRelatedQuoteTap;

  @override
  Widget build(BuildContext context) {
    final hasRelatedQuotes = fact.relatedQuoteIds.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Kicker-Band
        Container(
          color: AppColors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            fact.todayInHistory
                ? 'WELTGESCHICHTE · HEUTE VOR ${_yearsAgo(fact.dateIso)} JAHREN'
                : 'WELTGESCHICHTE · ${fact.dateDisplay.toUpperCase()}',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Body container
        Container(
          color: AppColors.paper,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Headline (NOT italic)
              Text(
                fact.headline,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  color: AppColors.ink,
                  letterSpacing: -0.3,
                  height: 1.65,
                ),
              ),

              const SizedBox(height: 20),

              // Body text
              Text(
                fact.body,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: AppColors.ink,
                  letterSpacing: -0.2,
                  height: 1.65,
                ),
              ),

              const SizedBox(height: 20),

              // Red divider line
              Container(width: 28, height: 2, color: AppColors.red),

              const SizedBox(height: 16),

              // Source and metadata
              Wrap(
                spacing: 8,
                children: <Widget>[
                  if (fact.region.isNotEmpty)
                    CategoryChip(label: _capitalize(fact.region)),
                  ...fact.category.map(
                    (String cat) => CategoryChip(label: cat),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Marxistische Einordnung section
        Container(
          color: AppColors.paper.withValues(alpha: 0.7),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'MARXISTISCHE EINORDNUNG',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                fact.connectionToMarx,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        // Related quote button
        if (hasRelatedQuotes)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: ElevatedButton(
              onPressed: onRelatedQuoteTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                'VERWANDTES ZITAT LESEN →',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _yearsAgo(String dateIso) {
    try {
      final date = DateTime.parse(dateIso);
      final now = DateTime.now();
      final years = now.year - date.year;
      return years.toString();
    } catch (e) {
      return '?';
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
