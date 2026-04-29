import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

Future<void> showTestPaywallPopup(
  BuildContext context, {
  required VoidCallback onTestLogin,
  required VoidCallback onTestUnlock,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: AppColors.paper,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 2, width: 42, color: AppColors.red),
              const SizedBox(height: 12),
              Text(
                'TEST PAYWALL',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Zitate App Pro',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dieser Popup ist nur zum Testen. Du kannst Test-Login und Test-Unlock simulieren.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppColors.inkLight,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              const _FeatureBullet(text: 'Deep Dive und Lernpfade'),
              const _FeatureBullet(text: 'Smart Reminder 2.0'),
              const _FeatureBullet(text: 'Notizen, Audio und Wochenausgabe'),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onTestLogin();
                      },
                      child: const Text('TEST LOGIN'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onTestUnlock();
                      },
                      child: const Text('PRO TESTEN'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _FeatureBullet extends StatelessWidget {
  const _FeatureBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 5,
            height: 5,
            color: AppColors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
