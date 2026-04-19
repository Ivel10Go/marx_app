import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';

class PdfExportService {
  static final _red = PdfColor.fromInt(0xFFC41E1E);
  static final _ink = PdfColor.fromInt(0xFF1A1A1A);
  static final _muted = PdfColor.fromInt(0xFF555555);

  Future<void> exportFavorites({
    required List<Quote> quotes,
    required List<HistoryFact> facts,
  }) async {
    final doc = pw.Document();
    final fonts = await _loadFonts();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (_) => _buildTitlePage(
          quotes: quotes.length,
          facts: facts.length,
          fonts: fonts,
        ),
      ),
    );

    for (final quote in quotes) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (_) => _buildQuotePage(quote, fonts),
        ),
      );
    }

    for (final fact in facts) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (_) => _buildFactPage(fact, fonts),
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (_) async => doc.save());
  }

  Future<_PdfFonts> _loadFonts() async {
    Future<pw.Font?> load(String path) async {
      try {
        final data = await rootBundle.load(path);
        return pw.Font.ttf(data);
      } catch (_) {
        return null;
      }
    }

    final playfairRegular = await load(
      'assets/fonts/PlayfairDisplay-Regular.ttf',
    );
    final playfairItalic = await load(
      'assets/fonts/PlayfairDisplay-Italic.ttf',
    );
    final plexRegular = await load('assets/fonts/IBMPlexSans-Regular.ttf');
    final plexBold = await load('assets/fonts/IBMPlexSans-Bold.ttf');

    return _PdfFonts(
      serif: playfairRegular,
      serifItalic: playfairItalic,
      sans: plexRegular,
      sansBold: plexBold,
    );
  }

  pw.Widget _buildTitlePage({
    required int quotes,
    required int facts,
    required _PdfFonts fonts,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          'DAS KAPITAL',
          style: pw.TextStyle(font: fonts.sansBold, fontSize: 28, color: _ink),
        ),
        pw.SizedBox(height: 8),
        pw.Container(width: double.infinity, height: 2, color: _red),
        pw.SizedBox(height: 22),
        pw.Text(
          'Meine Favoriten',
          style: pw.TextStyle(font: fonts.sans, fontSize: 18, color: _ink),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          'Exportiert am ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
          style: pw.TextStyle(font: fonts.sans, fontSize: 12, color: _muted),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          '$quotes gespeicherte Zitate',
          style: pw.TextStyle(font: fonts.sans, fontSize: 12, color: _ink),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          '$facts gespeicherte Fakten',
          style: pw.TextStyle(font: fonts.sans, fontSize: 12, color: _ink),
        ),
      ],
    );
  }

  pw.Widget _buildQuotePage(Quote quote, _PdfFonts fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          '${quote.source.toUpperCase()} · ${quote.year}',
          style: pw.TextStyle(
            font: fonts.sansBold,
            fontSize: 9,
            color: _red,
            letterSpacing: 1.4,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          '„${quote.textDe}“',
          style: pw.TextStyle(
            font: fonts.serifItalic,
            fontSize: 20,
            color: _ink,
            lineSpacing: 6,
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Container(width: 40, height: 2, color: _red),
        pw.SizedBox(height: 10),
        pw.Text(
          quote.source,
          style: pw.TextStyle(font: fonts.sans, fontSize: 11, color: _muted),
        ),
        pw.SizedBox(height: 24),
        pw.Text(
          'ERKLAERUNG',
          style: pw.TextStyle(
            font: fonts.sansBold,
            fontSize: 8,
            color: _red,
            letterSpacing: 1.2,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          quote.explanationLong,
          style: pw.TextStyle(
            font: fonts.sans,
            fontSize: 11,
            color: _muted,
            lineSpacing: 3,
          ),
        ),
        pw.Spacer(),
        pw.Text(
          quote.category.join(' · '),
          style: pw.TextStyle(font: fonts.sans, fontSize: 8, color: _muted),
        ),
      ],
    );
  }

  pw.Widget _buildFactPage(HistoryFact fact, _PdfFonts fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          'WELTGESCHICHTE · ${fact.dateDisplay.toUpperCase()}',
          style: pw.TextStyle(
            font: fonts.sansBold,
            fontSize: 9,
            color: _red,
            letterSpacing: 1.4,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          fact.headline,
          style: pw.TextStyle(font: fonts.serif, fontSize: 22, color: _ink),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          fact.body,
          style: pw.TextStyle(font: fonts.sans, fontSize: 12, color: _ink),
        ),
        pw.SizedBox(height: 16),
        pw.Container(width: 40, height: 2, color: _red),
        pw.SizedBox(height: 10),
        pw.Text(
          'MARXISTISCHE EINORDNUNG',
          style: pw.TextStyle(
            font: fonts.sansBold,
            fontSize: 8,
            color: _red,
            letterSpacing: 1.2,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          fact.connectionToMarx,
          style: pw.TextStyle(
            font: fonts.sans,
            fontSize: 11,
            color: _muted,
            lineSpacing: 3,
          ),
        ),
      ],
    );
  }
}

class _PdfFonts {
  const _PdfFonts({this.serif, this.serifItalic, this.sans, this.sansBold});

  final pw.Font? serif;
  final pw.Font? serifItalic;
  final pw.Font? sans;
  final pw.Font? sansBold;
}
