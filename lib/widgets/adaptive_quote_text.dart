import 'package:flutter/material.dart';

class AdaptiveQuoteText extends StatelessWidget {
  const AdaptiveQuoteText({
    required this.text,
    this.style,
    this.minFontSize = 22,
    this.maxFontSize = 38,
    this.maxLines = 8,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final double minFontSize;
  final double maxFontSize;
  final int maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final resolvedStyle = (style ?? DefaultTextStyle.of(context).style)
            .copyWith(height: style?.height ?? 1.35);
        final fontSize = _resolveFontSize(
          context: context,
          text: text,
          style: resolvedStyle,
          maxWidth: constraints.maxWidth.isFinite ? constraints.maxWidth : 320,
        );

        return Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: resolvedStyle.copyWith(fontSize: fontSize),
        );
      },
    );
  }

  double _resolveFontSize({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final textScaler = MediaQuery.textScalerOf(context);
    for (double size = maxFontSize; size >= minFontSize; size -= 1) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: style.copyWith(fontSize: size),
        ),
        maxLines: maxLines,
        textDirection: Directionality.of(context),
        textScaler: textScaler,
      )..layout(maxWidth: maxWidth);

      if (!painter.didExceedMaxLines) {
        return size;
      }
    }

    return minFontSize;
  }
}
