import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_card.dart';

/// Item reutilizable para dashboards con diseño minimalista
class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const DashboardItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return CustomCard(
      onTap: onTap,
      margin: const EdgeInsets.only(
        left: AppTheme.spacingMD,
        right: AppTheme.spacingMD,
        bottom: AppTheme.spacingSM,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.gray100,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
            child: Icon(
              icon,
              color: iconColor ?? primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.gray400,
          ),
        ],
      ),
    );
  }
}
