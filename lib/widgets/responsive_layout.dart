import 'package:flutter/material.dart';

/// Breakpoints for responsive design (Material 3)
class ResponsiveBreakpoints {
  /// Mobile: < 600dp
  static const int mobileMax = 599;

  /// Tablet: 600-839dp
  static const int tabletMin = 600;
  static const int tabletMax = 839;

  /// Desktop: >= 840dp
  static const int desktopMin = 840;
}

/// Utility extension for responsive design
extension ResponsiveContext on BuildContext {
  /// Returns screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// True if device is in portrait orientation
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// True if device is in landscape orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// True if screen width < 600dp (mobile)
  bool get isMobile => screenWidth < ResponsiveBreakpoints.tabletMin;

  /// True if screen width 600-839dp (tablet)
  bool get isTablet =>
      screenWidth >= ResponsiveBreakpoints.tabletMin &&
      screenWidth <= ResponsiveBreakpoints.tabletMax;

  /// True if screen width >= 840dp (desktop)
  bool get isDesktop => screenWidth >= ResponsiveBreakpoints.desktopMin;

  /// Returns appropriate padding based on screen size
  EdgeInsets get responsivePadding {
    if (isDesktop) {
      return const EdgeInsets.all(32);
    } else if (isTablet) {
      return const EdgeInsets.all(24);
    }
    return const EdgeInsets.all(16);
  }

  /// Returns appropriate horizontal padding
  double get responsiveHorizontalPadding {
    if (isDesktop) {
      return 32;
    } else if (isTablet) {
      return 24;
    }
    return 16;
  }

  /// Returns number of columns for grid layout
  int get gridColumns {
    if (isDesktop) {
      return 4;
    } else if (isTablet) {
      return 2;
    }
    return 1;
  }
}

/// Widget wrapper for responsive layouts
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop ?? tablet ?? mobile;
    } else if (context.isTablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
