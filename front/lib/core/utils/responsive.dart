import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_theme.dart';

/// Utilidades para diseño responsive
/// Detecta el tipo de dispositivo y proporciona breakpoints
class Responsive {
  /// Breakpoints para diferentes tamaños de pantalla
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double wideDesktopBreakpoint = 1440;

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

  /// Verifica si es wide desktop (pantallas grandes)
  static bool isWideDesktop(BuildContext context) {
    return screenWidth(context) >= wideDesktopBreakpoint;
  }

  /// Verifica si es mobile o tablet
  static bool isMobileOrTablet(BuildContext context) {
    return screenWidth(context) < desktopBreakpoint;
  }

  /// Verifica si estamos en web
  static bool get isWeb => kIsWeb;

  /// Obtiene el tipo de dispositivo
  static DeviceType getDeviceType(BuildContext context) {
    if (isMobile(context)) return DeviceType.mobile;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Obtiene el padding horizontal según el dispositivo
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return AppTheme.spacingMD;
    if (isTablet(context)) return AppTheme.spacingXL;
    if (isWideDesktop(context)) return AppTheme.spacingXXL * 2;
    return AppTheme.spacingXXL;
  }

  /// Obtiene el ancho máximo del contenido según el dispositivo
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 800;
    if (isWideDesktop(context)) return 1400;
    return 1200;
  }

  /// Obtiene el número de columnas para grids según el dispositivo
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    if (isWideDesktop(context)) return 4;
    return 3;
  }

  /// Obtiene el número de columnas para dashboards
  static int getDashboardColumns(BuildContext context) {
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

  /// Obtiene el ancho del sidebar para web/desktop
  static double getSidebarWidth(BuildContext context) {
    if (isWideDesktop(context)) return 280;
    return 240;
  }

  /// Obtiene si debe mostrar sidebar
  static bool shouldShowSidebar(BuildContext context) {
    return isDesktop(context);
  }

  /// Obtiene el aspect ratio para cards según el dispositivo
  static double getCardAspectRatio(BuildContext context) {
    if (isMobile(context)) return 3.0;
    if (isTablet(context)) return 2.5;
    return 2.2;
  }

  /// Obtiene el espaciado entre items de grid
  static double getGridSpacing(BuildContext context) {
    if (isMobile(context)) return AppTheme.spacingSM;
    if (isTablet(context)) return AppTheme.spacingMD;
    return AppTheme.spacingLG;
  }

  /// Widget builder condicional basado en el tamaño de pantalla
  static Widget builder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Retorna un valor basado en el tamaño de pantalla
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}
