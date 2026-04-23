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
      path: '/thinkers',
      label: 'DENKER',
      icon: Icons.psychology_outlined,
    ),
    _NavDestination(
      path: '/favorites',
      label: 'FAVORITEN',
      icon: Icons.favorite_border_rounded,
    ),
    _NavDestination(path: '/quiz', label: 'QUIZ', icon: Icons.quiz_outlined),
    _NavDestination(path: '/settings', label: 'EINST.', icon: Icons.tune),
  ];

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

              return GestureDetector(
                onTap: () => context.go(destination.path),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      destination.icon,
                      size: 16,
                      color: isActive
                          ? AppColors.paper
                          : const Color(0xFF666666),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destination.label,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? AppColors.paper
                            : const Color(0xFF666666),
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (isActive) ...<Widget>[
                      const SizedBox(height: 4),
                      Container(width: 24, height: 1, color: AppColors.red),
                    ],
                  ],
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
    required this.path,
    required this.label,
    required this.icon,
  });
  final String path;
  final String label;
  final IconData icon;
}
