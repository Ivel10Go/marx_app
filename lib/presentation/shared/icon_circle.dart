import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    required this.icon,
    this.background,
    this.iconColor = Colors.white,
    this.size = 40,
  });

  final IconData icon;
  final Color? background;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg = background ?? AppColors.paperDark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: Icon(icon, color: iconColor, size: size * 0.52),
      ),
    );
  }
}
