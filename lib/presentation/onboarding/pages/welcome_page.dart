import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.paper,
          border: Border(
            left: BorderSide(color: AppColors.ink, width: 1),
            right: BorderSide(color: AppColors.ink, width: 1),
            bottom: BorderSide(color: AppColors.ink, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Zitatatlas',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              Container(width: 44, height: 2, color: AppColors.red),
              const SizedBox(height: 20),
              Text(
                'Taeglich ein Gedanke. Taeglich ein Fakt.',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Die App verbindet Zitate mit einer ruhigen, personalisierten Tagesausgabe.',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppColors.inkLight,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Du entscheidest, welche Quellen und Themen im Feed haeufiger auftauchen.',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppColors.inkLight,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
