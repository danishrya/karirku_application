import 'package:flutter/material.dart';

/// Centralized color palette for KarirKu app.
/// All colors used across the app should reference this class.
class AppColors {
  AppColors._();

  // ─── Primary ───────────────────────────────────────────
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // ─── Accent / Employer ─────────────────────────────────
  static const Color accent = Color(0xFF06B6D4);
  static const Color accentLight = Color(0xFF67E8F9);
  static const Color accentDark = Color(0xFF0891B2);

  // ─── Dark Navy ─────────────────────────────────────────
  static const Color navy = Color(0xFF1A1D3E);
  static const Color navyLight = Color(0xFF27214D);

  // ─── Semantic ──────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ─── Neutral / Surface ─────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE5E7EB);

  // ─── Text ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Gradients ─────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient employerGradient = LinearGradient(
    colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1D3E), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Chip / Tag Colors ─────────────────────────────────
  static const Color chipBlueBackground = Color(0xFFDBEAFE);
  static const Color chipBlueText = Color(0xFF2563EB);
  static const Color chipGreenBackground = Color(0xFFD1FAE5);
  static const Color chipGreenText = Color(0xFF059669);
  static const Color chipAmberBackground = Color(0xFFFEF3C7);
  static const Color chipAmberText = Color(0xFFD97706);
  static const Color chipPurpleBackground = Color(0xFFEDE9FE);
  static const Color chipPurpleText = Color(0xFF7C3AED);
}
