import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema centralizado de la aplicación
/// Sistema de colores primarios dinámico que se propaga a todo el proyecto
/// Fuentes: Sora para títulos, Montserrat para cuerpo
class AppTheme {
  // ============================================
  // COLOR PRIMARIO - CAMBIAR AQUÍ PARA CAMBIAR TODO
  // ============================================
  /// Color primario de la aplicación
  /// Cambia este color y se actualizará en todo el proyecto
  static const Color primaryColor = Color(0xFF000000); // Negro por defecto
  
  // Puedes cambiar a cualquier color, por ejemplo:
  // static const Color primaryColor = Color(0xFF2563EB); // Azul
  // static const Color primaryColor = Color(0xFF059669); // Verde
  // static const Color primaryColor = Color(0xFFDC2626); // Rojo
  // static const Color primaryColor = Color(0xFF7C3AED); // Púrpura

  // ============================================
  // COLORES DERIVADOS DEL PRIMARIO
  // ============================================
  
  /// Color primario oscuro (para hover, estados activos)
  static Color get primaryDark => _darkenColor(primaryColor, 0.2);
  
  /// Color primario claro (para fondos suaves)
  static Color get primaryLight => _lightenColor(primaryColor, 0.9);
  
  /// Color primario con opacidad para fondos
  static Color get primaryWithOpacity => primaryColor.withValues(alpha: 0.1);
  
  /// Color para texto sobre fondo primario
  static Color get onPrimary => _getContrastColor(primaryColor);
  
  // Colores base
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryBlack = Color(0xFF000000);
  
  // Escala de grises (se mantienen constantes para consistencia)
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);
  
  // Color de error (rojo)
  static const Color errorRed = Color(0xFFDC2626);
  
  // Colores de estado
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningYellow = Color(0xFFF59E0B);
  
  // ============================================
  // ESPACIADOS
  // ============================================
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ============================================
  // BORDER RADIUS
  // ============================================
  static const double radiusXS = 2.0;
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;

  // ============================================
  // ELEVACIONES
  // ============================================
  static const double elevationNone = 0.0;
  static const double elevationSM = 1.0;
  static const double elevationMD = 2.0;
  static const double elevationLG = 4.0;

  // ============================================
  // FUNCIONES AUXILIARES PARA COLORES
  // ============================================
  
  /// Oscurece un color
  static Color _darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Aclara un color
  static Color _lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Obtiene el color de contraste (blanco o negro) para un color dado
  static Color _getContrastColor(Color color) {
    // Calcula la luminosidad relativa
    final luminance = color.computeLuminance();
    // Si la luminosidad es mayor a 0.5, usa negro, sino blanco
    return luminance > 0.5 ? primaryBlack : primaryWhite;
  }

  // ============================================
  // FUENTES GOOGLE FONTS
  // ============================================
  
  /// Fuente Sora para títulos y encabezados
  static TextStyle sora({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.sora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
  
  /// Fuente Montserrat para cuerpo y texto general
  static TextStyle montserrat({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // ============================================
  // TEMA PRINCIPAL
  // ============================================
  
  static ThemeData get lightTheme {
    // TextTheme con Google Fonts
    final textTheme = TextTheme(
      // Títulos con Sora
      displayLarge: sora(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -1,
      ),
      displayMedium: sora(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displaySmall: sora(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: sora(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      headlineSmall: sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      titleLarge: sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: sora(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleSmall: sora(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      // Cuerpo con Montserrat
      bodyLarge: montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      bodyMedium: montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: gray700,
      ),
      bodySmall: montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: gray500,
      ),
      labelLarge: montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // ColorScheme basado en el color primario
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: onPrimary,
        secondary: gray800,
        onSecondary: primaryWhite,
        error: errorRed,
        onError: primaryWhite,
        surface: primaryWhite,
        onSurface: primaryColor,
        surfaceContainerHighest: gray100,
        outline: gray300,
        outlineVariant: gray200,
      ),
      // TextTheme con Google Fonts
      textTheme: textTheme,
      // Scaffold
      scaffoldBackgroundColor: primaryWhite,
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryWhite,
        foregroundColor: primaryColor,
        elevation: elevationNone,
        centerTitle: true,
        titleTextStyle: sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryColor,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
          size: 24,
        ),
      ),
      // Cards
      cardTheme: CardThemeData(
        color: primaryWhite,
        elevation: elevationSM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          side: const BorderSide(color: gray200, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: spacingMD,
          vertical: spacingSM,
        ),
      ),
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: gray300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: gray300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMD,
          vertical: spacingMD,
        ),
        labelStyle: montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: gray600,
        ),
        hintStyle: montserrat(
          fontSize: 14,
          color: gray400,
        ),
      ),
      // Botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimary,
          elevation: elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLG,
            vertical: spacingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // Botones de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMD,
            vertical: spacingSM,
          ),
          textStyle: montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Dividers
      dividerTheme: const DividerThemeData(
        color: gray200,
        thickness: 1,
        space: 1,
      ),
      // ListTiles
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMD,
          vertical: spacingSM,
        ),
        titleTextStyle: sora(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        subtitleTextStyle: montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: gray600,
        ),
      ),
      // Iconos
      iconTheme: IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: gray800,
        contentTextStyle: montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryWhite,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        elevation: elevationMD,
      ),
    );
  }
}
