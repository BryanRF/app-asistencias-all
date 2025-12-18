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
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.spacingMD,
        horizontal: Responsive.isMobile(context) 
            ? AppTheme.spacingSM 
            : 0,
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReporteAsistenciasPage(
                  alumnoId: user.id,
                  titulo: 'Mis Asistencias',
                ),
              ),
            );
          },
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReporteAsistenciasPage(
                  alumnoId: user.id,
                  titulo: 'Mi Reporte de Asistencias',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
