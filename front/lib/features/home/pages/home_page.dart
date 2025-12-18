import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/responsive_container.dart';
import '../../auth/pages/login_page.dart';
import '../widgets/profesor_dashboard.dart';
import '../widgets/alumno_dashboard.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final userModel = UserModel.fromJson(user);
    final authService = AuthService();
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isMobile 
              ? 'Bienvenido' 
              : 'Bienvenido, ${userModel.nombreCompleto}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          if (!isMobile)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  userModel.nombreCompleto,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: ResponsiveCenter(
        child: userModel.isProfesor || userModel.isAdmin
            ? ProfesorDashboard(user: userModel)
            : AlumnoDashboard(user: userModel),
      ),
    );
  }
}

