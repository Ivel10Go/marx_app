import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/godmode_colors.dart';
import '../core/utils/share_card_renderer.dart';
import '../data/models/quote.dart';
import 'category_chip.dart';

class GodmodeQuoteCard extends StatefulWidget {
  const GodmodeQuoteCard({required this.quote, this.onTap, super.key});

  final Quote quote;
  final VoidCallback? onTap;

  @override
  State<GodmodeQuoteCard> createState() => _GodmodeQuoteCardState();
}

class _GodmodeQuoteCardState extends State<GodmodeQuoteCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: GodmodeColors.card,
            border: Border.all(
              color: GodmodeColors.accent.withValues(alpha: _glowAnim.value * 0.7),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: GodmodeColors.accent.withValues(alpha: _glowAnim.value * 0.25),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Kicker band
          Container(
            color: GodmodeColors.accent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '☭ ${widget.quote.source.toUpperCase()} · ${widget.quote.year}',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.8,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.quote.chapter,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 8,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        await ShareCardRenderer().shareQuote(
                          widget.quote,
                          context,
                          isGodmode: true,
                        );
                      },
                      child: const Icon(
                        Icons.ios_share_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main card content
          Material(
            color: GodmodeColors.card,
            child: InkWell(
              onTap: widget.onTap,
              splashColor: GodmodeColors.accent.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.quote.textDe,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 21,
                        fontStyle: FontStyle.italic,
                        color: GodmodeColors.text,
                        height: 1.65,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(width: 28, height: 2, color: GodmodeColors.accent),
                    const SizedBox(height: 10),
                    Text(
                      '— ${widget.quote.source}',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 11,
                        color: GodmodeColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.quote.category
                          .take(3)
                          .map(
                            (String item) => _GodmodeChip(label: item),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GodmodeChip extends StatelessWidget {
  const _GodmodeChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: GodmodeColors.accent.withValues(alpha: 0.5)),
        color: GodmodeColors.surface,
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.ibmPlexSans(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: GodmodeColors.accent,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// Exported for use in other widgets
class GodmodeChip extends StatelessWidget {
  const GodmodeChip({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) => _GodmodeChip(label: label);
}
