import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'adaptive_quote_text.dart';
import '../core/theme/app_colors.dart';
import '../data/models/quote.dart';
import '../presentation/home/widgets/tts_button.dart';
import 'category_chip.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({
    required this.quote,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.onShare,
    super.key,
  });

  final Quote quote;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final isLongQuote = _isLongQuote(quote.textDe);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Kicker-Band (rot)
        Container(
          color: AppColors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${quote.source.toUpperCase()} · ${quote.year}',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.redOnRed,
                    letterSpacing: 1.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onShare != null) ...<Widget>[
                IconButton(
                  onPressed: onShare,
                  icon: const Icon(Icons.ios_share_rounded),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  iconSize: 16,
                  color: AppColors.redOnRed,
                  tooltip: 'Teilen',
                ),
                const SizedBox(width: 4),
              ],
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
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Zitat-Text
                    AdaptiveQuoteText(
                      text: quote.textDe,
                      minFontSize: isLongQuote ? 20 : 24,
                      maxFontSize: isLongQuote ? 30 : 34,
                      maxLines: isLongQuote ? 6 : 7,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    if (isLongQuote) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        'Langes Zitat gekuerzt - tippen fuer Volltext',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkLight,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
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
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        TtsButton(contentId: quote.id, text: quote.textDe),
                        if (onTap != null) ...<Widget>[
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isLongQuote
                                  ? 'Tippen fuer Volltext und Erklaerung'
                                  : 'Tippen fuer Erklaerung und Kontext',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.red,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: AppColors.red,
                          ),
                        ],
                        if (trailing != null) ...<Widget>[
                          const SizedBox(width: 12),
                          Expanded(child: trailing!),
                        ],
                      ],
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

  bool _isLongQuote(String value) {
    final words = value
        .split(RegExp(r'\s+'))
        .where((part) => part.trim().isNotEmpty)
        .length;
    return value.length > 320 || words > 60;
  }
}
