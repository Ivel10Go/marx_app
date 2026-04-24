import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/thinker_quote.dart';

class ShareCardRenderer {
  final ScreenshotController _controller = ScreenshotController();

  Future<void> shareQuote(
    Quote quote,
    BuildContext context, {
    bool isGodmode = false,
  }) async {
    try {
      final image = await _controller.captureFromWidget(
        Material(
          child: isGodmode
              ? _buildGodmodeCard(quote)
              : _buildStandardCard(quote, Theme.of(context).colorScheme),
        ),
      );
      await _shareBytes(image);
    } catch (_) {
      // Fallback to text share
      await _shareText('„${quote.textDe}" – ${quote.source}, ${quote.year}');
    }
  }

  Future<void> shareThinkerQuote(
    ThinkerQuote quote,
    BuildContext context,
  ) async {
    try {
      final image = await _controller.captureFromWidget(
        Material(child: _buildThinkerCard(quote)),
      );
      await _shareBytes(image);
    } catch (_) {
      await _shareText(
        '„${quote.textDe}" – ${quote.author}, ${quote.source}',
      );
    }
  }

  Future<void> shareHistoryFact(
    HistoryFact fact,
    BuildContext context,
  ) async {
    try {
      final image = await _controller.captureFromWidget(
        Material(child: _buildFactCard(fact)),
      );
      await _shareBytes(image);
    } catch (_) {
      await _shareText('${fact.headline}\n\n${fact.body}');
    }
  }

  Widget _buildStandardCard(Quote quote, ColorScheme scheme) {
    return Container(
      width: 1080,
      height: 1350,
      padding: const EdgeInsets.all(56),
      color: const Color(0xFFEDE8DF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Red kicker
          Container(
            color: const Color(0xFFC41E1E),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              '${quote.source.toUpperCase()} · ${quote.year}',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          const Spacer(),
          Text(
            quote.textDe,
            style: GoogleFonts.playfairDisplay(
              fontSize: 58,
              fontStyle: FontStyle.italic,
              height: 1.6,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 36),
          Container(height: 3, width: 80, color: const Color(0xFFC41E1E)),
          const SizedBox(height: 28),
          Text(
            '— ${quote.source}',
            style: GoogleFonts.playfairDisplay(
              fontSize: 36,
              color: const Color(0xFF555555),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Das Kapital',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 28,
                letterSpacing: 0.8,
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGodmodeCard(Quote quote) {
    return Container(
      width: 1080,
      height: 1350,
      padding: const EdgeInsets.all(56),
      color: const Color(0xFF0A0A0A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Red kicker
          Container(
            color: const Color(0xFFFF1A1A),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              '☭ ${quote.source.toUpperCase()} · ${quote.year}',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          const Spacer(),
          Text(
            quote.textDe,
            style: GoogleFonts.playfairDisplay(
              fontSize: 58,
              fontStyle: FontStyle.italic,
              height: 1.6,
              color: const Color(0xFFEEEEEE),
            ),
          ),
          const SizedBox(height: 36),
          Container(height: 3, width: 80, color: const Color(0xFFFF1A1A)),
          const SizedBox(height: 28),
          Text(
            '— ${quote.source}',
            style: GoogleFonts.playfairDisplay(
              fontSize: 36,
              color: const Color(0xFF888888),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '☭ MARX GODMODE',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: const Color(0xFFFF1A1A).withValues(alpha: 0.8),
                ),
              ),
              Text(
                'Das Kapital',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 28,
                  letterSpacing: 0.8,
                  color: const Color(0xFFEEEEEE).withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThinkerCard(ThinkerQuote quote) {
    final yearLabel = quote.year < 0
        ? '${quote.year.abs()} v. Chr.'
        : '${quote.year}';
    return Container(
      width: 1080,
      height: 1350,
      padding: const EdgeInsets.all(56),
      color: const Color(0xFFEDE8DF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              '${quote.author.toUpperCase()} · $yearLabel',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEDE8DF),
                letterSpacing: 3,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '»${quote.textDe}«',
            style: GoogleFonts.playfairDisplay(
              fontSize: 56,
              fontStyle: FontStyle.italic,
              height: 1.6,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 36),
          Container(height: 3, width: 80, color: const Color(0xFF1A1A1A)),
          const SizedBox(height: 28),
          Text(
            '— ${quote.author}, ${quote.source}',
            style: GoogleFonts.playfairDisplay(
              fontSize: 34,
              color: const Color(0xFF555555),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Das Kapital',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 28,
                letterSpacing: 0.8,
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactCard(HistoryFact fact) {
    return Container(
      width: 1080,
      height: 1350,
      padding: const EdgeInsets.all(56),
      color: const Color(0xFFEDE8DF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: const Color(0xFFC41E1E),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'WELTGESCHICHTE · ${fact.dateDisplay.toUpperCase()}',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 2.5,
              ),
            ),
          ),
          const Spacer(),
          Text(
            fact.headline,
            style: GoogleFonts.playfairDisplay(
              fontSize: 54,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 36),
          Container(height: 3, width: 80, color: const Color(0xFFC41E1E)),
          const SizedBox(height: 28),
          Text(
            fact.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              height: 1.6,
              color: const Color(0xFF555555),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Das Kapital',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 28,
                letterSpacing: 0.8,
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareBytes(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/quote_share.png');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(<XFile>[XFile(file.path)]);
  }

  Future<void> _shareText(String text) async {
    await Share.share(text);
  }
}
