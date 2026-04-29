import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/image_loader.dart';
import '../../../data/models/history_fact.dart';
import 'tts_button.dart';
import '../../../widgets/category_chip.dart';

class FactBlock extends StatelessWidget {
  const FactBlock({
    required this.fact,
    this.onRelatedQuoteTap,
    this.onShareTap,
    super.key,
  });

  final HistoryFact fact;
  final VoidCallback? onRelatedQuoteTap;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    final hasRelatedQuotes = fact.relatedQuoteIds.isNotEmpty;
    final punchline = fact.funFact?.trim().isNotEmpty == true
        ? fact.funFact!.trim()
        : fact.headline;
    final quickContext = fact.funFact?.trim().isNotEmpty == true
        ? fact.headline
        : _firstSentence(fact.body);

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
            style: AppTheme.factBlockKicker,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Featured image
        if (fact.imageUrl != null && fact.imageUrl!.isNotEmpty)
          CachedImageLoader(
            imageUrl: fact.imageUrl!,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            cacheConfig: const ImageCacheConfig(
              cacheDurationDays: 7,
              maxMemoryCacheSizeMB: 50,
            ),
          ),

        // Body container
        Container(
          color: AppColors.paper,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.paperDark,
                  border: Border.all(color: AppColors.rule, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'HISTORISCHER KERN',
                      style: AppTheme.factBlockKickerRed,
                    ),
                    const SizedBox(height: 8),
                    Text(punchline, style: AppTheme.factBlockPunchline),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.rule,
                    ),
                    const SizedBox(height: 10),
                    Text(quickContext, style: AppTheme.factBlockQuickContext),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Text(fact.headline, style: AppTheme.factBlockHeadline),

              const SizedBox(height: 14),

              Text(fact.body, style: AppTheme.factBlockBody),

              if (fact.funFact != null &&
                  fact.funFact!.trim().isNotEmpty) ...<Widget>[
                const SizedBox(height: 14),
                Text('EINORDNUNG', style: AppTheme.factBlockLabel),
              ],

              const SizedBox(height: 18),

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
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  TtsButton(contentId: fact.id, text: fact.body),
                  const SizedBox(width: 12),
                  if (onShareTap != null)
                    OutlinedButton.icon(
                      onPressed: onShareTap,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.ink, width: 1),
                        foregroundColor: AppColors.ink,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      icon: const Icon(Icons.ios_share_rounded, size: 16),
                      label: Text(
                        'TEILEN',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
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

  String _firstSentence(String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return '';
    }

    final dotIndex = normalized.indexOf('.');
    if (dotIndex <= 0) {
      return normalized;
    }

    return normalized.substring(0, dotIndex + 1);
  }
}
