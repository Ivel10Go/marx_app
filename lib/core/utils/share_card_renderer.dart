import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/quote.dart';

class ShareCardRenderer {
  final ScreenshotController _controller = ScreenshotController();

  Future<void> shareQuote(Quote quote, BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;

    final image = await _controller.captureFromWidget(
      Material(
        child: Container(
          width: 1080,
          height: 1350,
          padding: const EdgeInsets.all(28),
          color: scheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer(),
              Text(
                quote.textDe,
                style: GoogleFonts.lora(
                  fontSize: 58,
                  fontStyle: FontStyle.italic,
                  height: 1.7,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 28),
              Container(height: 1, width: 220, color: scheme.primary),
              const SizedBox(height: 24),
              Text(
                quote.source,
                style: GoogleFonts.lora(
                  fontSize: 34,
                  color: scheme.onSurface.withValues(alpha: 0.82),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Karl Marx & Friedrich Engels',
                style: GoogleFonts.lora(
                  fontSize: 30,
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${quote.year}',
                style: GoogleFonts.lora(
                  fontSize: 30,
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Zitatatlas',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    letterSpacing: 0.8,
                    color: scheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await _shareBytes(image);
  }

  Future<void> _shareBytes(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/quote_share.png');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(<XFile>[XFile(file.path)]);
  }
}
