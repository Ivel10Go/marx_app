import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_colors.dart';
import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';

class ShareCardRenderer {
  final ScreenshotController _controller = ScreenshotController();

  Future<void> shareQuote(Quote quote, BuildContext context) async {
    try {
      final image = await _controller.captureFromWidget(
        _SharePage.quote(quote: quote),
      );

      await _shareBytes(image);
    } catch (_) {
      await Share.share(
        '"${quote.textDe}"\n— ${quote.source}, ${quote.year}\n${quote.explanationShort}',
      );
    }
  }

  Future<void> shareFact(HistoryFact fact, BuildContext context) async {
    try {
      final image = await _controller.captureFromWidget(
        _SharePage.fact(fact: fact),
      );

      await _shareBytes(image);
    } catch (_) {
      await Share.share(
        '${fact.funFact ?? fact.headline}\n${fact.headline}\n${fact.dateDisplay}',
      );
    }
  }

  Future<void> _shareBytes(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/quote_share.png');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(<XFile>[XFile(file.path)]);
  }
}

class _SharePage extends StatelessWidget {
  const _SharePage._({
    required this.kicker,
    required this.title,
    required this.body,
    required this.source,
    required this.footer,
    this.tagline,
  });

  factory _SharePage.quote({required Quote quote}) {
    return _SharePage._(
      kicker: '${quote.source.toUpperCase()} · ${quote.year}',
      title: quote.textDe,
      body: quote.explanationShort,
      source: quote.chapter,
      footer: 'ZITATATLAS',
      tagline: quote.category.take(3).join(' · '),
    );
  }

  factory _SharePage.fact({required HistoryFact fact}) {
    return _SharePage._(
      kicker: 'WELTGESCHICHTE · ${fact.dateDisplay.toUpperCase()}',
      title: fact.funFact ?? fact.headline,
      body: fact.body,
      source: fact.connectionToMarx,
      footer: 'ZITATATLAS',
      tagline: fact.category.take(3).join(' · '),
    );
  }

  final String kicker;
  final String title;
  final String body;
  final String source;
  final String footer;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paper,
      child: Container(
        width: 1080,
        height: 1350,
        color: AppColors.paper,
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: AppColors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                kicker,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.paper,
                border: Border.all(color: AppColors.ink, width: 2),
              ),
              padding: const EdgeInsets.all(36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 56,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: AppColors.ink,
                      height: 1.25,
                    ),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  Container(width: 120, height: 2, color: AppColors.red),
                  const SizedBox(height: 20),
                  Text(
                    body,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 24,
                      height: 1.55,
                      color: AppColors.ink,
                    ),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  if (tagline != null &&
                      tagline!.trim().isNotEmpty) ...<Widget>[
                    Text(
                      tagline!,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.red,
                        letterSpacing: 1.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    source,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkLight,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      footer,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkLight.withValues(alpha: 0.55),
                        letterSpacing: 1.0,
                      ),
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
