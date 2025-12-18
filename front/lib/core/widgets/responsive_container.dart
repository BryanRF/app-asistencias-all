import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../theme/app_theme.dart';

/// Container responsive que se adapta al tamaño de pantalla
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = padding?.horizontal ?? Responsive.getHorizontalPadding(context);
    final verticalPadding = padding?.vertical ?? AppTheme.spacingLG;
    final contentMaxWidth = maxWidth ?? Responsive.getMaxContentWidth(context);

    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: contentMaxWidth,
        ),
        child: child,
      ),
    );
  }
}

/// Wrapper para contenido centrado en web, full width en mobile
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return child;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Responsive.getMaxContentWidth(context),
        ),
        child: child,
      ),
    );
  }
}
