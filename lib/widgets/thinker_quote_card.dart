import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/share_card_renderer.dart';
import '../data/models/thinker_quote.dart';

class ThinkerQuoteCard extends StatelessWidget {
  const ThinkerQuoteCard({required this.thinkerQuote, this.onTap, super.key});

  final ThinkerQuote thinkerQuote;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final yearLabel = thinkerQuote.year < 0
        ? '${thinkerQuote.year.abs()} v. Chr.'
        : '${thinkerQuote.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Kicker band
        Container(
          color: AppColors.ink,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'DENKER · $yearLabel',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.paper,
                  letterSpacing: 1.8,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    thinkerQuote.source.toUpperCase(),
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 8,
                      color: AppColors.paper.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      await ShareCardRenderer().shareThinkerQuote(
                        thinkerQuote,
                        context,
                      );
                    },
                    child: Icon(
                      Icons.ios_share_rounded,
                      size: 14,
                      color: AppColors.paper,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Main card
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
                    // Author badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: AppColors.ink,
                      child: Text(
                        thinkerQuote.author.toUpperCase(),
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.paper,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '»${thinkerQuote.textDe}«',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 21,
                        fontStyle: FontStyle.italic,
                        color: AppColors.ink,
                        height: 1.65,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(width: 28, height: 2, color: AppColors.red),
                    const SizedBox(height: 10),
                    Text(
                      '— ${thinkerQuote.author}, ${thinkerQuote.source}',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 11,
                        color: AppColors.inkLight,
                      ),
                    ),
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
