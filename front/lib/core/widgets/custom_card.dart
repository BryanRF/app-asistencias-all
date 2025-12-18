import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Card personalizado con diseño minimalista consistente
class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin ?? EdgeInsets.zero,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.spacingMD),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        child: card,
      );
    }

    return card;
  }
}
