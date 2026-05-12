import 'package:flutter/material.dart';

/// Vordefinierte Farbpaletten basierend auf politischer Orientierung
/// Diese Struktur ist vorbereitet für zukünftige Theme-Anpassungen
abstract final class PoliticalThemeColors {
  // Neutral (Standard-App-Farben)
  static const Color neutralPrimary = Color(0xFFCC0000); // Rot
  static const Color neutralAccent = Color(0xFF2A2A2A); // Dunkelgrau
  static const Color neutralBackground = Color(0xFFF4EFE6); // Creme

  // Links-orientiert (Rot-Töne, sozialistische Assoziationen)
  static const Color leftPrimary = Color(0xFFB31E1E); // Tiefrot
  static const Color leftAccent = Color(0xFF1A1A1A); // Schwarz
  static const Color leftBackground = Color(0xFFF0F0F0); // Hellgrau

  // Rechts-orientiert (Blau-Töne, konservative Assoziationen)
  static const Color rightPrimary = Color(0xFF003DA5); // Dunkelblau
  static const Color rightAccent = Color(0xFF1A1A1A); // Schwarz
  static const Color rightBackground = Color(0xFFF8F9FA); // Sehr hellblau

  /// Gibt die Farbpalette für eine politische Orientierung zurück
  static ColorPalette getPaletteForLeaning(String politicalLeaning) {
    switch (politicalLeaning) {
      case 'left':
        return const ColorPalette(
          primary: leftPrimary,
          accent: leftAccent,
          background: leftBackground,
        );
      case 'right':
        return const ColorPalette(
          primary: rightPrimary,
          accent: rightAccent,
          background: rightBackground,
        );
      case 'neutral':
      default:
        return const ColorPalette(
          primary: neutralPrimary,
          accent: neutralAccent,
          background: neutralBackground,
        );
    }
  }
}

/// Datenstruktur für eine Theme-Farbpalette
class ColorPalette {
  const ColorPalette({
    required this.primary,
    required this.accent,
    required this.background,
  });

  final Color primary;
  final Color accent;
  final Color background;

  ColorPalette copyWith({Color? primary, Color? accent, Color? background}) {
    return ColorPalette(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
    );
  }
}
