import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../data/models/user_profile.dart';

class PoliticalLeaningParliamentPicker extends StatelessWidget {
  const PoliticalLeaningParliamentPicker({
    required this.selected,
    required this.onSelect,
    this.height = 150,
    super.key,
  });

  final PoliticalLeaning selected;
  final ValueChanged<PoliticalLeaning> onSelect;
  final double height;

  @override
  Widget build(BuildContext context) {
    final items = <({PoliticalLeaning value, IconData icon, String label})>[
      (
        value: PoliticalLeaning.left,
        icon: Icons.keyboard_double_arrow_left_rounded,
        label: 'Links',
      ),
      (
        value: PoliticalLeaning.centerLeft,
        icon: Icons.chevron_left_rounded,
        label: 'Mitte-Links',
      ),
      (
        value: PoliticalLeaning.neutral,
        icon: Icons.circle_outlined,
        label: 'Neutral',
      ),
      (
        value: PoliticalLeaning.liberal,
        icon: Icons.chevron_right_rounded,
        label: 'Liberal',
      ),
      (
        value: PoliticalLeaning.conservative,
        icon: Icons.keyboard_double_arrow_right_rounded,
        label: 'Konservativ',
      ),
    ];

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items.map((item) {
                final active = item.value == selected;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Tooltip(
                      message: item.label,
                      child: InkWell(
                        onTap: () => onSelect(item.value),
                        borderRadius: BorderRadius.zero,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.red.withValues(alpha: 0.12)
                                : AppColors.paper,
                            border: Border.all(
                              color: active ? AppColors.red : AppColors.rule,
                              width: active ? 1.6 : 1,
                            ),
                            boxShadow: active
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: AppColors.red.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                item.icon,
                                size: 24,
                                color: active
                                    ? AppColors.red
                                    : AppColors.inkMuted,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 12,
                                height: 2,
                                color: active ? AppColors.red : AppColors.rule,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _labelFor(selected),
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _labelFor(PoliticalLeaning leaning) {
    switch (leaning) {
      case PoliticalLeaning.left:
        return 'Links';
      case PoliticalLeaning.centerLeft:
        return 'Mitte-Links';
      case PoliticalLeaning.neutral:
        return 'Neutral';
      case PoliticalLeaning.liberal:
        return 'Liberal';
      case PoliticalLeaning.conservative:
        return 'Konservativ';
    }
  }
}
