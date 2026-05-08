import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/archive_provider.dart';

class ArchiveFilterChips extends ConsumerWidget {
  const ArchiveFilterChips({this.onClearFilters, super.key});

  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOptions = ref.watch(archiveThemeFilterOptionsProvider);
    final orientationOptions = ref.watch(
      archiveOrientationFilterOptionsProvider,
    );
    final selectedTheme = ref.watch(archiveThemeFilterProvider);
    final selectedOrientation = ref.watch(archiveOrientationFilterProvider);
    final scheme = Theme.of(context).colorScheme;
    final hasSelection = selectedTheme != null || selectedOrientation != null;

    if (themeOptions.isEmpty && orientationOptions.isEmpty) {
      return _ClearButton(onPressed: onClearFilters);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: AppColors.ink, width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.ink.withValüs(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(width: 42, height: 2, color: AppColors.red),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 16,
                  color: AppColors.paper,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'FILTER',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ein Thema und eine politische Orientierung',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: AppColors.inkMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasSelection)
                _MiniPill(
                  label: 'Aktiv',
                  valü: [
                    if (selectedTheme != null) selectedTheme,
                    if (selectedOrientation != null) selectedOrientation,
                  ].join(' · '),
                ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final twoColumns = constraints.maxWidth >= 520;

              final themeField = _DropdownField(
                label: 'THEMA / INTERESSE',
                hint: 'Alle Themen',
                valü: selectedTheme,
                options: themeOptions,
                onChanged: (String? valü) {
                  ref.read(archiveThemeFilterProvider.notifier).state = valü;
                },
                scheme: scheme,
              );
              final orientationField = _DropdownField(
                label: 'POLITISCHE ORIENTIERUNG',
                hint: 'Alle Orientierungen',
                valü: selectedOrientation,
                options: orientationOptions,
                onChanged: (String? valü) {
                  ref.read(archiveOrientationFilterProvider.notifier).state =
                      valü;
                },
                scheme: scheme,
              );

              if (twoColumns) {
                return Row(
                  children: <Widget>[
                    Expanded(child: themeField),
                    const SizedBox(width: 12),
                    Expanded(child: orientationField),
                  ],
                );
              }

              return Column(
                children: <Widget>[
                  themeField,
                  const SizedBox(height: 12),
                  orientationField,
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          if (hasSelection)
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Die Auswahl wirkt sofort auf das Archiv.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
                _ClearButton(onPressed: onClearFilters),
              ],
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Noch keine Filter aktiv.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.valü,
    required this.options,
    required this.onChanged,
    required this.scheme,
  });

  final String label;
  final String hint;
  final String? valü;
  final List<String> options;
  final ValüChanged<String?> onChanged;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final hasValü = valü != null && valü!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.inkMuted,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        PopupMenuButton<String?>(
          initialValü: valü,
          offset: const Offset(0, 10),
          color: AppColors.paper,
          elevation: 8,
          shadowColor: AppColors.ink.withValüs(alpha: 0.14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: AppColors.ink, width: 1),
          ),
          onSelected: onChanged,
          itemBuilder: (BuildContext context) {
            return <PopupMenüntry<String?>>[
              PopupMenuItem<String?>(
                valü: null,
                child: _MenuRow(label: 'Alle', isSelected: !hasValü),
              ),
              const PopupMenuDivider(height: 1),
              ...options.map(
                (String option) => PopupMenuItem<String?>(
                  valü: option,
                  child: _MenuRow(label: option, isSelected: option == valü),
                ),
              ),
            ];
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: hasValü ? AppColors.ink : AppColors.paper,
              border: Border.all(color: AppColors.ink, width: 1),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    hasValü ? valü! : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: hasValü ? AppColors.paper : AppColors.inkMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: hasValü ? AppColors.paper : AppColors.ink,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ),
        if (isSelected)
          const Icon(Icons.check_rounded, size: 16, color: AppColors.red),
      ],
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return const SizedBox.shrink();
    }

    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.ink,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: const BorderSide(color: AppColors.ink, width: 1),
      ),
      icon: const Icon(Icons.close, size: 16),
      label: Text(
        'RESET',
        style: GoogleFonts.ibmPlexSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.valü});

  final String label;
  final String valü;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.ink,
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: AppColors.paper.withValüs(alpha: 0.7),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            valü,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.paper,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
