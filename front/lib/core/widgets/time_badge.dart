import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Badge para mostrar horas (inicio y fin)
class TimeBadge extends StatelessWidget {
  final String horaInicio;
  final String horaFin;
  final TimeBadgeSize size;

  const TimeBadge({
    super.key,
    required this.horaInicio,
    required this.horaFin,
    this.size = TimeBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(_getRadius()),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            horaInicio,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _getFontSize(),
            ),
          ),
          Text(
            horaFin,
            style: TextStyle(
              color: AppTheme.gray500,
              fontSize: _getFontSize() - 2,
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case TimeBadgeSize.small:
        return const EdgeInsets.all(AppTheme.spacingXS);
      case TimeBadgeSize.medium:
        return const EdgeInsets.all(AppTheme.spacingSM);
      case TimeBadgeSize.large:
        return const EdgeInsets.all(AppTheme.spacingMD);
    }
  }

  double _getRadius() {
    switch (size) {
      case TimeBadgeSize.small:
        return AppTheme.radiusXS;
      case TimeBadgeSize.medium:
        return AppTheme.radiusSM;
      case TimeBadgeSize.large:
        return AppTheme.radiusMD;
    }
  }

  double _getFontSize() {
    switch (size) {
      case TimeBadgeSize.small:
        return 10;
      case TimeBadgeSize.medium:
        return 14;
      case TimeBadgeSize.large:
        return 18;
    }
  }
}

enum TimeBadgeSize {
  small,
  medium,
  large,
}
