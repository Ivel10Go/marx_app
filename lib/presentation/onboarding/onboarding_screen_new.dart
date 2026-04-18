import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/providers/settings_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;

  static const _pages = <({String title, String body, IconData icon})>[
    (
      title: 'Willkommen bei Das Kapital',
      body:
          'Jeden Tag ein Zitat, ruhig gesetzt wie eine Seite in einer edlen Ausgabe.',
      icon: Icons.library_books_rounded,
    ),
    (
      title: 'Benachrichtigungen',
      body:
          'Zur gewaehlten Uhrzeit erscheint der erste Satz des Tages direkt auf dem Sperrbildschirm.',
      icon: Icons.notifications_active,
    ),
    (
      title: 'Widgets auf dem Homescreen',
      body:
          'Ein Widget bringt das Zitat in Blickweite, ohne die Stille des Lesens zu unterbrechen.',
      icon: Icons.library_books_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDecoratedScaffold(
      child: Column(
        children: <Widget>[
          // Header
          Container(
            color: AppColors.paper,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'EINFUEHRUNG',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      '${_index + 1}/${_pages.length}',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(width: 40, height: 2, color: AppColors.red),
                const SizedBox(height: 12),
                // Progress bar
                Container(
                  height: 1,
                  color: AppColors.rule,
                  child: FractionallySizedBox(
                    widthFactor: (_index + 1) / _pages.length,
                    child: Container(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (int value) {
                setState(() {
                  _index = value;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 32,
                  ),
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
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.ink,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                page.icon,
                                size: 40,
                                color: AppColors.red,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page.body,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 12,
                              color: AppColors.ink,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _BroadsheetOutlineButton(
                    onPressed: () async {
                      await ref
                          .read(settingsControllerProvider.notifier)
                          .markOnboardingSeen();
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                    label: 'UEBERSPRINGEN',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BroadsheetButton(
                    onPressed: () async {
                      if (_index == _pages.length - 1) {
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .markOnboardingSeen();
                        if (context.mounted) {
                          context.go('/');
                        }
                        return;
                      }
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                    label: _index == _pages.length - 1 ? 'FERTIG' : 'WEITER',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BroadsheetButton extends StatelessWidget {
  const _BroadsheetButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ink,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.paper,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BroadsheetOutlineButton extends StatelessWidget {
  const _BroadsheetOutlineButton({
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
