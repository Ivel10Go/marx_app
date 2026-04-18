import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({required this.selectedIndex, super.key});

  final int selectedIndex;

  static const _destinations = <_NavDestination>[
    _NavDestination(path: '/', label: 'HEUTE'),
    _NavDestination(path: '/archive', label: 'ARCHIV'),
    _NavDestination(path: '/favorites', label: 'FAVORITEN'),
    _NavDestination(path: '/settings', label: 'EINST.'),
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
  const _NavDestination({required this.path, required this.label});
  final String path;
  final String label;
}
