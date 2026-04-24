import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({
    required this.score,
    required this.onRestart,
    super.key,
  });

  final int score;
  final VoidCallback onRestart;

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  int _highscore = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highscore = prefs.getInt('quiz_highscore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDecoratedScaffold(
      bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: AppColors.red,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                'ERGEBNIS',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.redOnRed,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 26),
            Text(
              '${widget.score}/10',
              style: GoogleFonts.playfairDisplay(
                fontSize: 64,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _rating(widget.score),
              style: GoogleFonts.ibmPlexSans(
                fontSize: 14,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bester: $_highscore/10',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 12,
                color: AppColors.inkLight,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onRestart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  foregroundColor: AppColors.paper,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('NOCHMAL'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/archive'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.ink),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('ZUM ARCHIV ->'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _rating(int score) {
    if (score <= 3) {
      return 'Mehr lesen.';
    }
    if (score <= 6) {
      return 'Solide Basis.';
    }
    if (score <= 9) {
      return 'Guter Genosse.';
    }
    return 'Proletarisches Klassenbewusstsein.';
  }
}
