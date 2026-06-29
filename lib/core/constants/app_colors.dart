import 'package:flutter/material.dart';

/// Centralized color palette for KarirKu app.
/// Updated to match vibrant Figma design.
class AppColors {
  AppColors._();

  // ─── Primary ───────────────────────────────────────────
  static const Color primary = Color(0xFF0062FF); // Vibrant Blue
  static const Color primaryLight = Color(0xFF5C9DFF);
  static const Color primaryDark = Color(0xFF004BCC);

  // ─── Accent / Employer ─────────────────────────────────
  static const Color accent = Color(0xFF00C853); // Vibrant Green
  static const Color accentLight = Color(0xFF5EFB89);
  static const Color accentDark = Color(0xFF009624);

  // ─── Dark Navy ─────────────────────────────────────────
  static const Color navy = Color(0xFF1E293B);
  static const Color navyLight = Color(0xFF334155);

  // ─── Semantic ──────────────────────────────────────────
  static const Color success = Color(0xFF00C853);
  static const Color successLight = Color(0xFFB9F6CA);
  static const Color warning = Color(0xFFFFB300);
  static const Color warningLight = Color(0xFFFFECB3);
  static const Color error = Color(0xFFFF3B30);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color info = Color(0xFF0062FF);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ─── Neutral / Surface ─────────────────────────────────
  static const Color background = Color(0xFFF4F7F9);
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
    colors: [Color(0xFF0062FF), Color(0xFF3384FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient employerGradient = LinearGradient(
    colors: [Color(0xFF009624), Color(0xFF00C853)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0062FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0062FF), Color(0xFF5C9DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Chip / Tag Colors ─────────────────────────────────
  static const Color chipBlueBackground = Color(0xFFE3F2FD);
  static const Color chipBlueText = Color(0xFF0062FF);
  static const Color chipGreenBackground = Color(0xFFE8F5E9);
  static const Color chipGreenText = Color(0xFF00C853);
  static const Color chipAmberBackground = Color(0xFFFFF8E1);
  static const Color chipAmberText = Color(0xFFFFB300);
  static const Color chipPurpleBackground = Color(0xFFF3E5F5);
  static const Color chipPurpleText = Color(0xFF9C27B0);
}
