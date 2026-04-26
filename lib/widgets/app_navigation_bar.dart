import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({required this.selectedIndex, super.key});

  final int selectedIndex;

  static const _destinations = <_NavDestination>[
    _NavDestination(path: '/', label: 'HEUTE', icon: Icons.today_outlined),
    _NavDestination(
      path: '/archive',
      label: 'ARCHIV',
      icon: Icons.library_books_outlined,
    ),
    _NavDestination(
      path: '/settings',
      label: 'EINST.',
      icon: Icons.settings_outlined,
    ),
    _NavDestination(label: 'MEHR', icon: Icons.grid_view_rounded, isMore: true),
  ];

  Future<void> _showMoreSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _MoreItem(
                label: 'Favoriten',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go('/favorites');
                },
              ),
              _MoreItem(
                label: 'Quiz',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go('/quiz');
                },
              ),
              _MoreItem(
                label: 'Denker',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go('/thinkers');
                },
              ),
              _MoreItem(
                label: 'Einführung',
                isLast: true,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go('/onboarding');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _destinations.asMap().entries.map((entry) {
              final index = entry.key;
              final destination = entry.value;
              final isActive = index == selectedIndex;

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (destination.isMore) {
                        _showMoreSheet(context);
                        return;
                      }
                      if (isActive || destination.path == null) {
                        return;
                      }
                      context.go(destination.path!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            destination.icon,
                            size: 16,
                            color: isActive
                                ? AppColors.paper
                                : AppColors.inkMuted,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            destination.label,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? AppColors.paper
                                  : AppColors.inkMuted,
                              letterSpacing: 1.2,
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            opacity: isActive ? 1 : 0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: 24,
                                height: 1,
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    this.path,
    required this.label,
    required this.icon,
    this.isMore = false,
  });
  final String? path;
  final String label;
  final IconData icon;
  final bool isMore;
}

class _MoreItem extends StatelessWidget {
  const _MoreItem({
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.zero,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: isLast
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.rule, width: 1),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
