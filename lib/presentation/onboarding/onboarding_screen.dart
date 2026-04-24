import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../domain/providers/quote_sources_provider.dart';
import '../../domain/providers/user_profile_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import 'pages/interests_page.dart';
import 'pages/quote_discovery_page.dart';
import 'pages/notification_permission_page.dart';
import 'pages/political_leaning_page.dart';
import 'pages/welcome_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;
  final Set<String> _selectedInterests = <String>{};
  final Set<String> _selectedSources = <String>{};
  PoliticalLeaning _leaning = PoliticalLeaning.neutral;
  QuoteDiscoverySelection _quoteDiscoverySelection =
      QuoteDiscoverySelection.interests;

  static const _pageCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index == 2 && _selectedInterests.isEmpty) {
      setState(() {});
      return;
    }

    if (_index == _pageCount - 1) {
      await ref
          .read(userProfileProvider.notifier)
          .saveProfile(
            historicalInterests: _selectedInterests.toList(),
            politicalLeaning: _leaning,
            quoteDiscoveryMode:
                _quoteDiscoverySelection == QuoteDiscoverySelection.manual
                ? QuoteDiscoveryMode.manual
                : QuoteDiscoveryMode.interests,
            selectedSources: _selectedSources.toList(),
          );
      ref.invalidate(userProfileProvider);
      if (mounted) {
        context.go('/');
      }
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sourcesAsync = ref.watch(availableQuoteSourcesProvider);

    return AppDecoratedScaffold(
      child: Column(
        children: <Widget>[
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
                      'ONBOARDING',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      '${_index + 1}/$_pageCount',
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
                Container(
                  height: 1,
                  color: AppColors.rule,
                  child: FractionallySizedBox(
                    widthFactor: (_index + 1) / _pageCount,
                    child: Container(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int value) {
                setState(() {
                  _index = value;
                });
              },
              children: <Widget>[
                const WelcomePage(),
                NotificationPermissionPage(
                  onAllow: () => NotificationService.instance.initialize(),
                  onSkip: _next,
                ),
                InterestsPage(
                  selected: _selectedInterests,
                  onToggle: (String value) {
                    setState(() {
                      if (_selectedInterests.contains(value)) {
                        _selectedInterests.remove(value);
                      } else {
                        _selectedInterests.add(value);
                      }
                    });
                  },
                ),
                QuoteDiscoveryPage(
                  mode: _quoteDiscoverySelection,
                  sources: _selectedSources,
                  availableSources:
                      sourcesAsync.valueOrNull ?? const <String>[],
                  onModeChanged: (QuoteDiscoverySelection value) {
                    setState(() {
                      _quoteDiscoverySelection = value;
                    });
                  },
                  onToggleSource: (String value) {
                    setState(() {
                      if (_selectedSources.contains(value)) {
                        _selectedSources.remove(value);
                      } else {
                        _selectedSources.add(value);
                      }
                    });
                  },
                ),
                PoliticalLeaningPage(
                  selected: _leaning,
                  onSelect: (PoliticalLeaning value) {
                    setState(() {
                      _leaning = value;
                    });
                  },
                  onSkip: () {
                    setState(() {
                      _leaning = PoliticalLeaning.neutral;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: <Widget>[
                if (_index > 0)
                  Expanded(
                    child: _OutlineActionButton(
                      label: 'ZURUECK',
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                if (_index > 0) const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    label: _index == _pageCount - 1 ? 'FERTIG' : 'WEITER',
                    onTap: _next,
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      child: InkWell(
        onTap: onTap,
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
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.ink)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
