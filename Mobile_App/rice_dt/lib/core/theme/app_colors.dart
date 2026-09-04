import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────
  static const darkForest = Color(0xFF1A3A2A); // deep header green
  static const leafGreen = Color(0xFF2D6A4F); // primary action green
  static const sageLight = Color(0xFF95D5B2); // accent / subtitle
  static const sageMint = Color(0xFFD8F3DC); // icon backgrounds, chips
  static const riceGold = Color(0xFFE9B84A); // warning / amber

  // ── Semantic ─────────────────────────────────────────────────────
  static const error = Color(0xFFB5290F); // diseased / delete
  static const errorLight = Color(0xFFFFE5E0); // error background
  static const success = Color(0xFF2D6A4F); // healthy
  static const successLight = Color(0xFFD8F3DC); // healthy background

  // ── Light theme surfaces ─────────────────────────────────────────
  static const lightBackground = Color(0xFFF0FAF4); // scaffold
  static const lightSurface = Color(0xFFFFFFFF); // cards
  static const lightSurface2 = Color(0xFFF8FCF9); // inner tiles
  static const lightBorder = Color(0xFFB7E4C7); // borders / dividers

  // ── Dark theme surfaces ──────────────────────────────────────────
  static const darkBackground = Color(0xFF0D1A12); // scaffold
  static const darkSurface = Color(0xFF1A2E20); // cards
  static const darkSurface2 = Color(0xFF22402C); // inner tiles
  static const darkBorder = Color(0xFF2D5038); // borders / dividers

  // ── Text — light ─────────────────────────────────────────────────
  static const lightTextPrimary = Color(0xFF1A3A2A);
  static const lightTextSecondary = Color(0xFF6B6B6B);
  static const lightTextHint = Color(0xFFB0B0B0);

  // ── Text — dark ──────────────────────────────────────────────────
  static const darkTextPrimary = Color(0xFFF0FAF4);
  static const darkTextSecondary = Color(0xFF95D5B2);
  static const darkTextHint = Color(0xFF4A6B55);
}
