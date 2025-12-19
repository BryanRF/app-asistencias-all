import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_sidebar.dart';
import '../../auth/pages/login_page.dart';
import '../../horarios/pages/horarios_page.dart';
import '../../reportes/pages/reporte_asistencias_page.dart';
import '../widgets/profesor_dashboard.dart';
import '../widgets/alumno_dashboard.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  late UserModel _userModel;
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _userModel = UserModel.fromJson(widget.user);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _onItemSelected(int index) {
    if (index == _currentIndex) return;
    
    _animationController.reverse().then((_) {
      setState(() => _currentIndex = index);
      _animationController.forward();
    });
  }

  Widget _buildCurrentPage() {
    final isProfesor = _userModel.isProfesor || _userModel.isAdmin;

    if (isProfesor) {
      switch (_currentIndex) {
        case 1:
        case 2:
          return HorariosPage(profesorId: _userModel.id);
        case 3:
          return _buildReportesSelector();
        default:
          return ProfesorDashboard(user: _userModel);
      }
    } else {
      switch (_currentIndex) {
        case 1:
          return ReporteAsistenciasPage(
            alumnoId: _userModel.id,
            titulo: 'Mis Asistencias',
          );
        case 3:
          return ReporteAsistenciasPage(
            alumnoId: _userModel.id,
            titulo: 'Mi Reporte de Asistencias',
          );
        default:
          return AlumnoDashboard(user: _userModel);
      }
    }
  }

  Widget _buildReportesSelector() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assessment_outlined,
            size: 80,
            color: AppTheme.gray300,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            'Seleccione una sección desde sus horarios',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.gray500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingLG),
          ElevatedButton.icon(
            onPressed: () => _onItemSelected(2),
            icon: const Icon(Icons.schedule),
            label: const Text('Ver Horarios'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.shouldShowSidebar(context);
    final isMobile = Responsive.isMobile(context);

    if (isDesktop) {
      return _buildDesktopLayout();
    } else {
      return _buildMobileLayout(isMobile);
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AppSidebar(
            user: _userModel,
            currentIndex: _currentIndex,
            onItemSelected: _onItemSelected,
            onLogout: _handleLogout,
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                _buildDesktopTopBar(),
                // Content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _currentIndex == 0
                        ? _buildDashboardContent()
                        : _buildCurrentPage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLG,
        vertical: AppTheme.spacingMD,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            _getPageTitle(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          _buildCurrentDateTime(),
        ],
      ),
    );
  }

  Widget _buildCurrentDateTime() {
    final now = DateTime.now();
    final weekdays = ['', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final months = ['', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
                    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMD,
        vertical: AppTheme.spacingSM,
      ),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: AppTheme.gray500),
          const SizedBox(width: AppTheme.spacingSM),
          Text(
            '${weekdays[now.weekday]}, ${now.day} de ${months[now.month]}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    final isProfesor = _userModel.isProfesor || _userModel.isAdmin;
    
    switch (_currentIndex) {
      case 0:
        return 'Panel Principal';
      case 1:
        return isProfesor ? 'Tomar Lista' : 'Mis Asistencias';
      case 2:
        return isProfesor ? 'Mis Horarios' : 'Mi Horario';
      case 3:
        return 'Reportes';
      default:
        return 'Panel Principal';
    }
  }

  Widget _buildDashboardContent() {
    final isProfesor = _userModel.isProfesor || _userModel.isAdmin;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeCard(),
          const SizedBox(height: AppTheme.spacingLG),
          // Quick actions
          Text(
            'Acciones Rápidas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          isProfesor
              ? _buildProfesorQuickActions()
              : _buildAlumnoQuickActions(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final isProfesor = _userModel.isProfesor || _userModel.isAdmin;
    final now = DateTime.now();
    String greeting;
    
    if (now.hour < 12) {
      greeting = 'Buenos días';
    } else if (now.hour < 18) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            AppTheme.gray800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Text(
                  isProfesor 
                      ? 'Prof. ${_userModel.nombres}'
                      : _userModel.nombreCompleto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Text(
                  isProfesor
                      ? 'Bienvenido al sistema de asistencias'
                      : 'DNI: ${_userModel.dni}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _userModel.nombres.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfesorQuickActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.getDashboardColumns(context);
        final spacing = Responsive.getGridSpacing(context);
        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _buildQuickActionCard(
              icon: Icons.list_alt,
              title: 'Tomar Lista',
              subtitle: 'Registrar asistencias',
              color: AppTheme.successGreen,
              onTap: () => _onItemSelected(1),
              width: itemWidth,
            ),
            _buildQuickActionCard(
              icon: Icons.schedule,
              title: 'Mis Horarios',
              subtitle: 'Ver horarios de clases',
              color: Theme.of(context).colorScheme.primary,
              onTap: () => _onItemSelected(2),
              width: itemWidth,
            ),
            _buildQuickActionCard(
              icon: Icons.assessment,
              title: 'Reportes',
              subtitle: 'Ver estadísticas',
              color: AppTheme.warningYellow,
              onTap: () => _onItemSelected(3),
              width: itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlumnoQuickActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.getDashboardColumns(context);
        final spacing = Responsive.getGridSpacing(context);
        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _buildQuickActionCard(
              icon: Icons.check_circle,
              title: 'Mis Asistencias',
              subtitle: 'Ver historial',
              color: AppTheme.successGreen,
              onTap: () => _onItemSelected(1),
              width: itemWidth,
            ),
            _buildQuickActionCard(
              icon: Icons.schedule,
              title: 'Mi Horario',
              subtitle: 'Horario de clases',
              color: Theme.of(context).colorScheme.primary,
              onTap: () => _onItemSelected(2),
              width: itemWidth,
            ),
            _buildQuickActionCard(
              icon: Icons.assessment,
              title: 'Mi Reporte',
              subtitle: 'Estadísticas de asistencia',
              color: AppTheme.warningYellow,
              onTap: () => _onItemSelected(3),
              width: itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: _HoverCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: AppTheme.spacingMD),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isMobile ? 'Bienvenido' : 'Bienvenido, ${_userModel.nombreCompleto}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          if (!isMobile)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  _userModel.nombreCompleto,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _userModel.isProfesor || _userModel.isAdmin
            ? ProfesorDashboard(user: _userModel)
            : AlumnoDashboard(user: _userModel),
      ),
    );
  }
}

// Widget con efecto hover para cards
class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverCard({
    required this.child,
    required this.onTap,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: _isHovered 
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : AppTheme.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
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
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
