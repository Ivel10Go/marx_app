import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_colors.dart';
import 'quote_attribution.dart';
import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';

class ShareCardRenderer {
  final ScreenshotController _controller = ScreenshotController();

  Future<void> shareQuote(Quote quote, BuildContext context) async {
    final fallbackText = _quoteShareText(quote);
    try {
      final image = await _controller.captureFromWidget(
        _ShareCanvas.quote(quote: quote),
      );

      await _shareBytes(
        image,
        fallbackText: fallbackText,
        filePrefix: 'quote_share',
      );
    } catch (error, stackTrace) {
      debugPrint('[ShareCardRenderer] quote share failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await Share.share(fallbackText);
    }
  }

  Future<void> shareFact(HistoryFact fact, BuildContext context) async {
    final fallbackText = _factShareText(fact);
    try {
      final image = await _controller.captureFromWidget(
        _ShareCanvas.fact(fact: fact),
      );

      await _shareBytes(
        image,
        fallbackText: fallbackText,
        filePrefix: 'fact_share',
      );
    } catch (error, stackTrace) {
      debugPrint('[ShareCardRenderer] fact share failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await Share.share(fallbackText);
    }
  }

  Future<void> _shareBytes(
    Uint8List bytes, {
    required String fallbackText,
    required String filePrefix,
  }) async {
    if (bytes.isEmpty) {
      await Share.share(fallbackText);
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/${filePrefix}_${DateTime.now().microsecondsSinceEpoch}.png',
    );

    try {
      await file.writeAsBytes(bytes, flush: true);
      if (await file.length() == 0) {
        await Share.share(fallbackText);
        return;
      }

      await Share.shareXFiles(<XFile>[XFile(file.path)]);
    } catch (error, stackTrace) {
      debugPrint('[ShareCardRenderer] file share failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await Share.share(fallbackText);
    }
  }

  String _quoteShareText(Quote quote) {
    final text = quote.textDe.trim().isNotEmpty
        ? quote.textDe.trim()
        : quote.textOriginal.trim();
    return '"$text"\n— ${quote.source}, ${quote.year}\n${quote.explanationShort}';
  }

  String _factShareText(HistoryFact fact) {
    return '${fact.funFact ?? fact.headline}\n${fact.headline}\n${fact.dateDisplay}';
  }
}

class _ShareCanvas extends StatelessWidget {
  const _ShareCanvas._({
    required this.kind,
    required this.kicker,
    required this.title,
    required this.source,
    required this.headerRight,
    this.tagline,
    this.body,
  });

  factory _ShareCanvas.quote({required Quote quote}) {
    return _ShareCanvas._(
      kind: _ShareCanvasKind.quote,
      kicker: '${quoteAuthorLabel(quote).toUpperCase()} · ${quote.year}',
      title: quote.textDe,
      source: '— ${quoteAuthorLabel(quote)}',
      headerRight: quote.chapter,
      tagline: quote.category.take(3).join(' · '),
    );
  }

  factory _ShareCanvas.fact({required HistoryFact fact}) {
    return _ShareCanvas._(
      kind: _ShareCanvasKind.fact,
      kicker: 'WELTGESCHICHTE · ${fact.dateDisplay.toUpperCase()}',
      title: fact.funFact ?? fact.headline,
      body: fact.body,
      source: fact.connectionToMarx,
      headerRight: fact.category.isNotEmpty
          ? fact.category.first.toUpperCase()
          : 'FAKT',
      tagline: fact.category.take(3).join(' · '),
    );
  }

  final _ShareCanvasKind kind;
  final String kicker;
  final String title;
  final String source;
  final String headerRight;
  final String? tagline;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paper,
      child: Container(
        width: 1080,
        height: 1350,
        color: AppColors.paper,
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Container(
            width: 1000,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.ink, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: AppColors.red,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          kicker,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.redOnRed,
                            letterSpacing: 1.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        headerRight.toUpperCase(),
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.redOnRed,
                          letterSpacing: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 54,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: AppColors.ink,
                          height: 1.2,
                        ),
                        maxLines: kind == _ShareCanvasKind.quote ? 8 : 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Container(width: 112, height: 2, color: AppColors.red),
                      const SizedBox(height: 16),
                      Text(
                        source,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink.withOpacity(0.86),
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (body != null && body!.trim().isNotEmpty) ...<Widget>[
                        const SizedBox(height: 18),
                        Text(
                          body!,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 20,
                            height: 1.45,
                            color: AppColors.ink,
                          ),
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (tagline != null &&
                          tagline!.trim().isNotEmpty) ...<Widget>[
                        const SizedBox(height: 20),
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
                      ],
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'ZITATATLAS',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink.withOpacity(0.55),
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
        ),
      ),
    );
  }
}

enum _ShareCanvasKind { quote, fact }
