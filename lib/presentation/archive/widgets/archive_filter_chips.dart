import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/archive_provider.dart';

class ArchiveFilterChips extends ConsumerWidget {
  const ArchiveFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(archiveFilterOptionsProvider);
    final active = ref.watch(archiveActiveFiltersProvider);

    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((String option) {
        final isSelected = active.contains(option);
        return FilterChip(
          label: Text(
            option.toUpperCase(),
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.paper : AppColors.ink,
              letterSpacing: 0.8,
            ),
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            final next = <String>{...active};
            if (selected) {
              next.add(option);
            } else {
              next.remove(option);
            }
            ref.read(archiveActiveFiltersProvider.notifier).state = next;
          },
          backgroundColor: AppColors.paper,
          selectedColor: AppColors.ink,
          side: const BorderSide(color: AppColors.ink, width: 1),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          showCheckmark: false,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}
