import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/widgets.dart';
import '../../horarios/pages/horarios_page.dart';

class ProfesorDashboard extends StatelessWidget {
  final UserModel user;

  const ProfesorDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    
    if (isDesktop || isTablet) {
      return _buildGridLayout(context);
    }
    
    return _buildMobileLayout(context);
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.spacingMD,
        horizontal: AppTheme.spacingSM,
      ),
      children: [
        UserInfoCard(
          user: user,
          variant: UserInfoCardVariant.horizontal,
        ),
        const SizedBox(height: AppTheme.spacingLG),
        DashboardItem(
          icon: Icons.list_alt,
          title: 'Tomar Lista',
          subtitle: 'Registrar asistencias de alumnos',
          onTap: () => _navigateToHorarios(context),
        ),
        DashboardItem(
          icon: Icons.schedule,
          title: 'Mis Horarios',
          subtitle: 'Ver mis horarios de clases',
          onTap: () => _navigateToHorarios(context),
        ),
        DashboardItem(
          icon: Icons.assessment,
          title: 'Reportes',
          subtitle: 'Ver reportes de asistencias por sección',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Seleccione una sección desde sus horarios'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info card - más ancha en desktop
          UserInfoCard(
            user: user,
            variant: UserInfoCardVariant.horizontal,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          // Título de sección
          Text(
            'Acciones Rápidas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          // Grid de acciones
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = Responsive.getDashboardColumns(context);
              final spacing = Responsive.getGridSpacing(context);
              final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _DashboardCard(
                    width: itemWidth,
                    icon: Icons.list_alt,
                    title: 'Tomar Lista',
                    subtitle: 'Registrar asistencias de alumnos',
                    color: AppTheme.successGreen,
                    onTap: () => _navigateToHorarios(context),
                  ),
                  _DashboardCard(
                    width: itemWidth,
                    icon: Icons.schedule,
                    title: 'Mis Horarios',
                    subtitle: 'Ver mis horarios de clases',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => _navigateToHorarios(context),
                  ),
                  _DashboardCard(
                    width: itemWidth,
                    icon: Icons.assessment,
                    title: 'Reportes',
                    subtitle: 'Ver reportes de asistencias',
                    color: AppTheme.warningYellow,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Seleccione una sección desde sus horarios'),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToHorarios(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HorariosPage(profesorId: user.id),
      ),
    );
  }
}

class _DashboardCard extends StatefulWidget {
  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered 
                ? widget.color.withValues(alpha: 0.05)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(
              color: _isHovered 
                  ? widget.color.withValues(alpha: 0.5)
                  : AppTheme.gray200,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.color.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0, -4))
              : Matrix4.identity(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    Row(
                      children: [
                        Text(
                          'Ir ahora',
                          style: TextStyle(
                            color: widget.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: widget.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
