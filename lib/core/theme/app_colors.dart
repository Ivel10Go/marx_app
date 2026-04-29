import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Papier & Tinte (Light Mode) ─────────────────
  static const paper = Color(0xFFEDE8DF);
  static const paperDark = Color(0xFFE5DFD4);
  static const ink = Color(0xFF1A1A1A);
  static const inkLight = Color(0xFF555555);
  static const inkMuted = Color(0xFF888888);
  static const rule = Color(0xFFBBB5AB);

  // ── Papier & Tinte (Dark Mode) ──────────────────
  static const darkBackground = Color(0xFF1A1A1A);
  static const darkPaper = Color(0xFF2A2A2A);
  static const darkPaperLight = Color(0xFF383838);
  static const darkInk = Color(0xFFEDE8DF);
  static const darkInkLight = Color(0xFFBBB5AB);
  static const darkRule = Color(0xFF444444);

  // ── Akzentrot (einzige Farbe, sparsam) ──────────
  static const red = Color(0xFFC41E1E);
  static const redDark = Color(0xFF9B1515);
  static const redOnRed = Color(0xFFFFFFFF);

  // ── Semantisch ──────────────────────────────────
  static const saved = Color(0xFF2A5C3F);
}
