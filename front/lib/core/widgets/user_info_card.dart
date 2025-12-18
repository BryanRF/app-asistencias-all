import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../theme/app_theme.dart';

/// Tarjeta de información del usuario reutilizable
/// Soporta diferentes variantes (profesor/alumno) y estilos
class UserInfoCard extends StatelessWidget {
  final UserModel user;
  final UserInfoCardVariant variant;
  final String? prefix;
  final bool useGradient;

  const UserInfoCard({
    super.key,
    required this.user,
    this.variant = UserInfoCardVariant.horizontal,
    this.prefix,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    final container = Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      decoration: BoxDecoration(
        color: useGradient ? null : primaryColor,
        gradient: useGradient
            ? LinearGradient(
                colors: [primaryColor, AppTheme.gray700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
      child: variant == UserInfoCardVariant.horizontal
          ? _buildHorizontalLayout(context, primaryColor, onPrimaryColor)
          : _buildVerticalLayout(context, primaryColor, onPrimaryColor),
    );

    return container;
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    Color primaryColor,
    Color onPrimaryColor,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            user.nombres.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getDisplayName(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                'DNI: ${user.dni}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    Color primaryColor,
    Color onPrimaryColor,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Text(
            user.nombres.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMD),
        Text(
          _getDisplayName(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          'DNI: ${user.dni}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _getDisplayName() {
    if (prefix != null) {
      return '$prefix ${user.apellidos.split(' ').first}, ${user.nombres}';
    }
    if (user.isProfesor || user.isAdmin) {
      return 'Prof. ${user.apellidos.split(' ').first}, ${user.nombres}';
    }
    return '${user.apellidos}, ${user.nombres}';
  }
}

enum UserInfoCardVariant {
  horizontal,
  vertical,
}
