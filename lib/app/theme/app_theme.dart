import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/app/theme/app_type.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: AppColors.onError,
      outline: AppColors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.divider,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: AppType.display,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: AppType.title,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: AppType.subtitle,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppType.body,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: AppType.caption,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: AppType.button,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppMetrics.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMetrics.radiusM),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusL),
        ),
      ),
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: Color(0xFF3730A3),
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
      error: Color(0xFFF87171),
      onError: Color(0xFF1F2937),
      outline: Color(0xFF334155),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      dividerColor: const Color(0xFF1E293B),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: AppType.display,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF1F5F9),
        ),
        headlineSmall: TextStyle(
          fontSize: AppType.title,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF1F5F9),
        ),
        titleMedium: TextStyle(
          fontSize: AppType.subtitle,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF1F5F9),
        ),
        bodyLarge: TextStyle(
          fontSize: AppType.body,
          color: Color(0xFFF1F5F9),
        ),
        bodySmall: TextStyle(
          fontSize: AppType.caption,
          color: Color(0xFF94A3B8),
        ),
        labelLarge: TextStyle(
          fontSize: AppType.button,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppMetrics.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMetrics.radiusM),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusL),
        ),
      ),
    );
  }
}
