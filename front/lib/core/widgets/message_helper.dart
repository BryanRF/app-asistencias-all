import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../common/error_helper.dart';

/// Helper para mostrar mensajes de forma consistente y amigable
class MessageHelper {
  /// Muestra un diálogo de error amigable (convierte error técnico a mensaje amigable)
  static void showError(BuildContext ctx, dynamic error, {String? errorContext}) {
    final message = errorContext != null 
        ? ErrorHelper.getContextualMessage(errorContext, error)
        : ErrorHelper.getFriendlyMessage(error);
    
    _showErrorDialog(ctx, message);
  }

  /// Muestra un diálogo de error con mensaje personalizado
  static void showErrorMessage(BuildContext ctx, String message) {
    _showErrorDialog(ctx, message);
  }

  /// Diálogo de error interno
  static void _showErrorDialog(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        icon: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          decoration: BoxDecoration(
            color: AppTheme.errorRed.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            color: AppTheme.errorRed,
            size: 32,
          ),
        ),
        title: const Text(
          '¡Ups!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.gray600),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo de éxito
  static void showSuccess(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        icon: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: AppTheme.successGreen,
            size: 32,
          ),
        ),
        title: const Text(
          '¡Listo!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.gray600),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.successGreen,
            ),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  /// Muestra un SnackBar de éxito (breve, no intrusivo)
  static void showSuccessSnackBar(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Muestra un SnackBar de advertencia
  static void showWarning(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white, size: 20),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.warningYellow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
      ),
    );
  }

  /// Muestra un SnackBar informativo
  static void showInfo(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.gray700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Muestra un diálogo de confirmación
  static Future<bool> showConfirmation(
    BuildContext ctx, {
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final result = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.gray600),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
