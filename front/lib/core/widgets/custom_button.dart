import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Botón personalizado con diseño minimalista consistente
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLG,
            vertical: AppTheme.spacingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
        ),
        child: _buildChild(context),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimaryColor = theme.colorScheme.onPrimary;
    
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppTheme.spacingSM),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
