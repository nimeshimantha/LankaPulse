import 'package:flutter/material.dart';

/// Centralized color tokens for LankaPulse application.
/// Strictly enforces the user-specified light and dark color palettes.
class AppColors {
  AppColors._();

  // --- LIGHT MODE PALETTE ---
  static const Color lightScaffoldBackground = Color(0xFFF8FAFC); // #F8FAFC
  static const Color lightCardBackground = Color(0xFFFFFFFF);     // #FFFFFF
  static const Color lightPrimary = Color(0xFF0284C7);            // #0284C7 (Sky Blue)
  static const Color lightSecondary = Color(0xFF38BDF8);          // #38BDF8
  static const Color lightTextPrimary = Color(0xFF0F172A);        // #0F172A
  static const Color lightTextSecondary = Color(0xFF64748B);      // Slate 500
  static const Color lightBorder = Color(0xFFE2E8F0);             // Slate 200

  // --- DARK MODE PALETTE ---
  static const Color darkScaffoldBackground = Color(0xFF0B132B);  // #0B132B
  static const Color darkCardBackground = Color(0xFF1C2541);      // #1C2541
  static const Color darkPrimary = Color(0xFF38BDF8);             // #38BDF8
  static const Color darkSecondary = Color(0xFF7DD3FC);           // #7DD3FC
  static const Color darkTextPrimary = Color(0xFFF1F5F9);         // #F1F5F9
  static const Color darkTextSecondary = Color(0xFF94A3B8);       // Slate 400
  static const Color darkBorder = Color(0xFF334155);              // Slate 700

  // --- SHARED ACCENTS ---
  static const Color accentGreen = Color(0xFF10B981); // Government / Success
  static const Color accentOrange = Color(0xFFF59E0B); // Private / Warning
  static const Color accentRed = Color(0xFFEF4444);    // Emergency SOS / High Priority
  static const Color accentPurple = Color(0xFF8B5CF6); // Tech / Internship

  // Priority Colors
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityLow = Color(0xFF10B981);
}
