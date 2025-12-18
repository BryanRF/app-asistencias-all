import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Badge para mostrar estados (Presente, Falta, Justificado, etc.)
class StatusBadge extends StatelessWidget {
  final String estado;
  final StatusBadgeSize size;

  const StatusBadge({
    super.key,
    required this.estado,
    this.size = StatusBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getEstadoColor(estado);
    final textStyle = _getTextStyle(context);

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(_getRadius()),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Text(
        estado,
        style: textStyle.copyWith(color: color),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'PRESENTE':
      case 'P':
        return AppTheme.successGreen;
      case 'FALTA':
      case 'F':
        return AppTheme.errorRed;
      case 'JUSTIFICADO':
      case 'J':
        return AppTheme.warningYellow;
      case 'TARDANZA':
      case 'T':
        return AppTheme.warningYellow;
      default:
        return AppTheme.gray500;
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case StatusBadgeSize.small:
        return Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 10);
      case StatusBadgeSize.medium:
        return Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12);
      case StatusBadgeSize.large:
        return Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case StatusBadgeSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXS,
          vertical: 2,
        );
      case StatusBadgeSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingSM,
          vertical: AppTheme.spacingXS,
        );
      case StatusBadgeSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingSM,
        );
    }
  }

  double _getRadius() {
    switch (size) {
      case StatusBadgeSize.small:
        return AppTheme.radiusXS;
      case StatusBadgeSize.medium:
        return AppTheme.radiusSM;
      case StatusBadgeSize.large:
        return AppTheme.radiusMD;
    }
  }
}

enum StatusBadgeSize {
  small,
  medium,
  large,
}
