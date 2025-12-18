import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Utilidades para diseño responsive
/// Detecta el tipo de dispositivo y proporciona breakpoints
class Responsive {
  /// Breakpoints para diferentes tamaños de pantalla
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Obtiene el ancho de la pantalla
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtiene la altura de la pantalla
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Verifica si es mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  /// Verifica si es tablet
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Verifica si es desktop/web
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= desktopBreakpoint;
  }

  /// Verifica si es mobile o tablet
  static bool isMobileOrTablet(BuildContext context) {
    return screenWidth(context) < desktopBreakpoint;
  }

  /// Obtiene el tipo de dispositivo
  static DeviceType getDeviceType(BuildContext context) {
    if (isMobile(context)) return DeviceType.mobile;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Obtiene el padding horizontal según el dispositivo
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return AppTheme.spacingMD;
    if (isTablet(context)) return AppTheme.spacingLG;
    return AppTheme.spacingXL;
  }

  /// Obtiene el ancho máximo del contenido según el dispositivo
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 800;
    return 1200;
  }

  /// Obtiene el número de columnas para grids según el dispositivo
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  /// Obtiene el tamaño del logo según el dispositivo
  static double getLogoSize(BuildContext context) {
    if (isMobile(context)) return 120;
    if (isTablet(context)) return 150;
    return 180;
  }

  /// Obtiene el ancho máximo del formulario de login
  static double getLoginFormMaxWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 500;
    return 450;
  }
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}
