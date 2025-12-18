import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Fila de información con icono y texto reutilizable
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final double? iconSize;
  final TextStyle? textStyle;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.iconSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize ?? 16,
          color: iconColor ?? AppTheme.gray500,
        ),
        const SizedBox(width: AppTheme.spacingXS),
        Flexible(
          child: Text(
            text,
            style: textStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
