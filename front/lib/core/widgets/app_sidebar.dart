import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

/// Sidebar para navegación en desktop/web
class AppSidebar extends StatelessWidget {
  final UserModel user;
  final int currentIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.user,
    required this.currentIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isProfesor = user.isProfesor || user.isAdmin;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header con logo
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLG),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                  child: Icon(
                    Icons.school,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asistencias',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sistema Escolar',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // User info
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            margin: const EdgeInsets.all(AppTheme.spacingMD),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, AppTheme.gray700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.nombres.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
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
                        user.nombreCompleto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isProfesor ? 'Profesor' : 'Alumno',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSM),
              children: [
                _SidebarSection(
                  title: 'Principal',
                  children: [
                    _SidebarItem(
                      icon: Icons.dashboard_outlined,
                      selectedIcon: Icons.dashboard,
                      label: 'Inicio',
                      isSelected: currentIndex == 0,
                      onTap: () => onItemSelected(0),
                    ),
                  ],
                ),
                if (isProfesor) ...[
                  _SidebarSection(
                    title: 'Asistencias',
                    children: [
                      _SidebarItem(
                        icon: Icons.list_alt_outlined,
                        selectedIcon: Icons.list_alt,
                        label: 'Tomar Lista',
                        isSelected: currentIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),
                      _SidebarItem(
                        icon: Icons.schedule_outlined,
                        selectedIcon: Icons.schedule,
                        label: 'Mis Horarios',
                        isSelected: currentIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),
                      _SidebarItem(
                        icon: Icons.assessment_outlined,
                        selectedIcon: Icons.assessment,
                        label: 'Reportes',
                        isSelected: currentIndex == 3,
                        onTap: () => onItemSelected(3),
                      ),
                    ],
                  ),
                ] else ...[
                  _SidebarSection(
                    title: 'Mi Información',
                    children: [
                      _SidebarItem(
                        icon: Icons.check_circle_outline,
                        selectedIcon: Icons.check_circle,
                        label: 'Mis Asistencias',
                        isSelected: currentIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),
                      _SidebarItem(
                        icon: Icons.schedule_outlined,
                        selectedIcon: Icons.schedule,
                        label: 'Mi Horario',
                        isSelected: currentIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),
                      _SidebarItem(
                        icon: Icons.assessment_outlined,
                        selectedIcon: Icons.assessment,
                        label: 'Mi Reporte',
                        isSelected: currentIndex == 3,
                        onTap: () => onItemSelected(3),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Logout
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            child: _SidebarItem(
              icon: Icons.logout_outlined,
              selectedIcon: Icons.logout,
              label: 'Cerrar Sesión',
              isSelected: false,
              onTap: onLogout,
              isDestructive: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SidebarSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppTheme.spacingMD,
            top: AppTheme.spacingLG,
            bottom: AppTheme.spacingSM,
          ),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.gray500,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  fontSize: 11,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    Color getIconColor() {
      if (widget.isDestructive) return AppTheme.errorRed;
      if (widget.isSelected) return primaryColor;
      if (_isHovered) return primaryColor;
      return AppTheme.gray600;
    }

    Color getTextColor() {
      if (widget.isDestructive) return AppTheme.errorRed;
      if (widget.isSelected) return primaryColor;
      if (_isHovered) return primaryColor;
      return AppTheme.gray700;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : _isHovered
                  ? AppTheme.gray100
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: widget.isSelected
              ? Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMD,
                vertical: AppTheme.spacingSM + 4,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isSelected ? widget.selectedIcon : widget.icon,
                    size: 22,
                    color: getIconColor(),
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: getTextColor(),
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (widget.isSelected)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
