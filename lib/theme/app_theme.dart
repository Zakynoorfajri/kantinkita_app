import 'package:flutter/material.dart';

/// Warna
class AppColors {
  static const primary = Color(0xFFF26B38); // Brand
  static const primaryDark = Color(0xFFD95525); // Brand dark
  static const textPrimary = Color(0xFF1C2333); // Ink
  static const textSecondary = Color(0xFF7C8598); // Muted
  static const border = Color(0xFFE6E9F2); // Line
  static const background = Color(0xFFF7F8FC);
  static const card = Colors.white;
  static const star = Color(0xFFFFB400);
  static const danger = Color(0xFFE5484D);
}

/// Spacing: 4 · 8 · 12 · 16 · 20 · 24 · 32. Padding layar kiri-kanan 24.
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const screenH = 24.0;
}

/// Radius: field & tombol 14 · kartu 16 · sheet 28 · chip 999.
class AppRadius {
  static const field = 14.0;
  static const card = 16.0;
  static const sheet = 28.0;
  static const chip = 999.0;
}

/// Tipografi
class AppText {
  /// Judul layar (Profil, Menu, Keranjang)
  static const screenTitle =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);

  /// Judul konten (Nasi Goreng Kampung)
  static const contentTitle = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w700, height: 1.2, color: AppColors.textPrimary);

  /// Body: 14 regular, line-height 1.6
  static const body = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, height: 1.6, color: AppColors.textPrimary);

  /// Caption / label: 11–13, warna muted
  static const caption =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
}

class AppTheme {
  static const softShadow = <BoxShadow>[
    BoxShadow(color: Color(0x141C2333), blurRadius: 16, offset: Offset(0, 6)),
  ];
  static const orangeShadow = <BoxShadow>[
    BoxShadow(color: Color(0x40F26B38), blurRadius: 18, offset: Offset(0, 8)),
  ];

  static ThemeData get light {
    const font = 'Poppins'; // fallback otomatis jika font belum didaftarkan
    final base = ThemeData.light(useMaterial3: true).textTheme;
    final text = base.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
      fontFamily: font,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: font,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.border,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      textTheme: text.copyWith(
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 14, height: 1.6),
      ),
    );
  }
}
