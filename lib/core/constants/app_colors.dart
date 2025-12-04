import 'package:flutter/material.dart';

/// Brand color palette - Modern & Clean aesthetic
/// Blue for UI, Gold reserved for rewards/badges
class AppColors {
  AppColors._();

  // Primary UI Palette (Blue-based)
  /// Deep Ocean Blue - Primary UI elements, headers
  static const Color primaryBlue = Color(0xFF1E3A8A); // Blue-900
  
  /// Sky Blue - Interactive elements, links
  static const Color skyBlue = Color(0xFF3B82F6); // Blue-500
  
  /// Light Blue - Hover states, highlights
  static const Color lightBlue = Color(0xFF60A5FA); // Blue-400
  
  /// Slate - Secondary UI elements
  static const Color slate = Color(0xFF475569); // Slate-600

  // Gradient Colors
  /// Primary gradient start
  static const Color gradientStart = Color(0xFF1E40AF); // Blue-800
  
  /// Primary gradient end
  static const Color gradientEnd = Color(0xFF3B82F6); // Blue-500
  
  /// Success gradient start
  static const Color successGradientStart = Color(0xFF059669); // Emerald-600
  
  /// Success gradient end
  static const Color successGradientEnd = Color(0xFF10B981); // Emerald-500

  // Rewards & Badges (Gold - only for achievements)
  /// Antique Gold - ONLY for rewards, badges, achievements
  static const Color rewardGold = Color(0xFFD97706); // Amber-600
  
  /// Light Gold - Achievement highlights
  static const Color lightGold = Color(0xFFFBBF24); // Amber-400
  
  /// Gold gradient start
  static const Color goldGradientStart = Color(0xFFD97706);
  
  /// Gold gradient end
  static const Color goldGradientEnd = Color(0xFFFBBF24);

  // Semantic Colors
  /// Sage Green - Positive indicators (payments, progress)
  static const Color success = Color(0xFF059669); // Emerald-600
  
  /// Muted Clay - Warnings, high interest
  static const Color warning = Color(0xFFDC2626); // Red-600
  
  /// Error red
  static const Color error = Color(0xFFB91C1C); // Red-700
  
  /// Info blue
  static const Color info = skyBlue;

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textOnDark = Color(0xFFF8FAFC); // Slate-50
  static const Color textMuted = Color(0xFF94A3B8); // Slate-400

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate-50
  static const Color backgroundDark = Color(0xFF0F172A); // Slate-900
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B); // Slate-800

  // Glassmorphism Colors
  static const Color glassLight = Color(0xCCFFFFFF); // White with 80% opacity
  static const Color glassDark = Color(0xCC1E293B); // Slate-800 with 80% opacity
  static const Color glassBlur = Color(0x40FFFFFF); // White with 25% opacity for blur effect
  
  // Glass borders
  static const Color glassBorderLight = Color(0x33FFFFFF); // White with 20% opacity
  static const Color glassBorderDark = Color(0x33475569); // Slate-600 with 20% opacity

  // Progress Colors (for debt progress bars)
  static const Color progressLow = Color(0xFFDC2626); // Red-600 - 0-33% paid
  static const Color progressMedium = Color(0xFFF59E0B); // Amber-500 - 34-66% paid
  static const Color progressHigh = Color(0xFF10B981); // Emerald-500 - 67-99% paid
  static const Color progressComplete = rewardGold; // Gold - 100% defeated

  // APR Fire Icons Colors (based on interest rate)
  static const Color aprLow = Color(0xFFF59E0B); // Amber-500 - < 10%
  static const Color aprMedium = Color(0xFFEA580C); // Orange-600 - 10-20%
  static const Color aprHigh = Color(0xFFDC2626); // Red-600 - > 20%

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color cardShadow = Color(0x1A000000);
  
  // Shimmer/Loading
  static const Color shimmerBase = Color(0xFFE2E8F0); // Slate-200
  static const Color shimmerHighlight = Color(0xFFF1F5F9); // Slate-100

  /// Create a linear gradient for primary UI elements
  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Create a linear gradient for success/progress elements
  static LinearGradient get successGradient => const LinearGradient(
        colors: [successGradientStart, successGradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Create a linear gradient for rewards/achievements
  static LinearGradient get rewardGradient => const LinearGradient(
        colors: [goldGradientStart, goldGradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Create a subtle background gradient
  static LinearGradient get backgroundGradient => const LinearGradient(
        colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}

