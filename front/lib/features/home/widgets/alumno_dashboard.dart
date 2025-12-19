import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/widgets.dart';
import '../../reportes/pages/reporte_asistencias_page.dart';

class AlumnoDashboard extends StatelessWidget {
  final UserModel user;

  const AlumnoDashboard({super.key, required this.user});

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
          variant: UserInfoCardVariant.vertical,
          useGradient: true,
        ),
        const SizedBox(height: AppTheme.spacingLG),
        DashboardItem(
          icon: Icons.check_circle,
          title: 'Mis Asistencias',
          subtitle: 'Ver mi historial de asistencias',
          onTap: () => _navigateToAsistencias(context),
        ),
        DashboardItem(
          icon: Icons.schedule,
          title: 'Mi Horario',
          subtitle: 'Ver mi horario de clases',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Próximamente disponible'),
              ),
            );
          },
        ),
        DashboardItem(
          icon: Icons.assessment,
          title: 'Mi Reporte',
          subtitle: 'Ver mi reporte de asistencias',
          onTap: () => _navigateToReporte(context),
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
          // User info card con avatar grande
          _buildProfileCard(context),
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
                    icon: Icons.check_circle,
                    title: 'Mis Asistencias',
                    subtitle: 'Ver historial de asistencias',
                    color: AppTheme.successGreen,
                    onTap: () => _navigateToAsistencias(context),
                  ),
                  _DashboardCard(
                    width: itemWidth,
                    icon: Icons.schedule,
                    title: 'Mi Horario',
                    subtitle: 'Horario de clases',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Próximamente disponible'),
                        ),
                      );
                    },
                  ),
                  _DashboardCard(
                    width: itemWidth,
                    icon: Icons.assessment,
                    title: 'Mi Reporte',
                    subtitle: 'Estadísticas de asistencia',
                    color: AppTheme.warningYellow,
                    onTap: () => _navigateToReporte(context),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            AppTheme.gray800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.nombres.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nombreCompleto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMD,
                    vertical: AppTheme.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                  child: Text(
                    'DNI: ${user.dni}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAsistencias(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporteAsistenciasPage(
          alumnoId: user.id,
          titulo: 'Mis Asistencias',
        ),
      ),
    );
  }

  void _navigateToReporte(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporteAsistenciasPage(
          alumnoId: user.id,
          titulo: 'Mi Reporte de Asistencias',
        ),
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
                          'Ver detalle',
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
