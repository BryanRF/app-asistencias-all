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
          variant: UserInfoCardVariant.horizontal,
        ),
        const SizedBox(height: AppTheme.spacingLG),
        DashboardItem(
          icon: Icons.list_alt,
          title: 'Tomar Lista',
          subtitle: 'Registrar asistencias de alumnos',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HorariosPage(profesorId: user.id),
              ),
            );
          },
        ),
        DashboardItem(
          icon: Icons.schedule,
          title: 'Mis Horarios',
          subtitle: 'Ver mis horarios de clases',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HorariosPage(profesorId: user.id),
              ),
            );
          },
        ),
        DashboardItem(
          icon: Icons.assessment,
          title: 'Reportes',
          subtitle: 'Ver reportes de asistencias por sección',
          onTap: () {
            // TODO: Mostrar selector de sección
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
}
