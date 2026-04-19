import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile.dart';

class PoliticalLeaningPage extends StatelessWidget {
  const PoliticalLeaningPage({
    required this.selected,
    required this.onSelect,
    required this.onSkip,
    super.key,
  });

  final PoliticalLeaning selected;
  final ValueChanged<PoliticalLeaning> onSelect;
  final VoidCallback onSkip;

  static const _options = <({PoliticalLeaning value, String label})>[
    (
      value: PoliticalLeaning.left,
      label: 'Links - Marxismus, Sozialismus, Anarchismus',
    ),
    (
      value: PoliticalLeaning.centerLeft,
      label: 'Mitte-Links - Sozialdemokratie, Gewerkschaften',
    ),
    (
      value: PoliticalLeaning.neutral,
      label: 'Neutral - Alles gleich gewichtet',
    ),
    (
      value: PoliticalLeaning.liberal,
      label: 'Liberal - Aufklaerung, Buergerrechte',
    ),
    (
      value: PoliticalLeaning.conservative,
      label: 'Konservativ - Tradition, Ordnung',
    ),
  ];

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'WO STEHST DU POLITISCH?',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.red,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Optional. Beeinflusst welche Zitate und Fakten bevorzugt werden.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: AppColors.inkLight,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    final isSelected = selected == option.value;
                    return Material(
                      color: isSelected ? AppColors.ink : AppColors.paper,
                      child: InkWell(
                        onTap: () => onSelect(option.value),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.ink
                                  : AppColors.rule,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            option.label,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              color: isSelected
                                  ? AppColors.paper
                                  : AppColors.ink,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onSkip,
                child: Text(
                  'Lieber nicht angeben -> Neutral',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: AppColors.inkMuted,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
