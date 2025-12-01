import 'package:flutter/material.dart';

/// Brand color palette based on brand_identity.md
/// Sophisticated & Grounded aesthetic for financial trust
class AppColors {
  AppColors._();

  // Primary Palette
  /// Deep Slate - Primary UI elements, headers, branding
  static const Color deepSlate = Color(0xFF334155);
  
  /// Antique Gold - Subtle accents, achievement markers
  static const Color antiqueGold = Color(0xFFD97706);
  
  /// Sage Green - Positive indicators (payments, progress)
  static const Color sageGreen = Color(0xFF059669);

  // Secondary & UI Palette
  /// Muted Clay - Debt alerts, negative numbers
  static const Color mutedClay = Color(0xFFB91C1C);
  
  /// Obsidian - Dark mode backgrounds, primary text
  static const Color obsidian = Color(0xFF0F172A);
  
  /// Vapor - Light mode backgrounds
  static const Color vapor = Color(0xFFF8FAFC);

  // Semantic Colors
  static const Color success = sageGreen;
  static const Color warning = antiqueGold;
  static const Color error = mutedClay;
  static const Color info = deepSlate;

  // Text Colors
  static const Color textPrimary = obsidian;
  static const Color textSecondary = deepSlate;
  static const Color textOnDark = vapor;
  static const Color textMuted = Color(0xFF64748B); // Slate-500

  // Background Colors
  static const Color backgroundLight = vapor;
  static const Color backgroundDark = obsidian;
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B); // Slate-800

  // Progress Colors (for debt progress bars)
  static const Color progressLow = mutedClay; // 0-33% paid
  static const Color progressMedium = antiqueGold; // 34-66% paid
  static const Color progressHigh = sageGreen; // 67-99% paid
  static const Color progressComplete = Color(0xFFFFD700); // Gold - 100% defeated

  // APR Fire Icons Colors (based on interest rate)
  static const Color aprLow = antiqueGold; // < 10%
  static const Color aprMedium = Color(0xFFEA580C); // 10-20%
  static const Color aprHigh = mutedClay; // > 20%

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color cardShadow = Color(0x1A000000);
}
