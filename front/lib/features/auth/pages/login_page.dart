import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/widgets.dart';
import '../../home/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  Future<void> _loadRememberedCredentials() async {
    final credentials = await _authService.getRememberedCredentials();
    if (credentials != null && mounted) {
      setState(() {
        _dniController.text = credentials['dni'] ?? '';
        _passwordController.text = credentials['password'] ?? '';
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login(
        _dniController.text.trim(),
        _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(user: response['user']),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, e, errorContext: 'login');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (isDesktop) {
      return _buildDesktopLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Panel izquierdo - Branding
          Expanded(
            flex: 3,
            child: _buildBrandingPanel(),
          ),
          // Panel derecho - Login form
          Expanded(
            flex: 2,
            child: _buildLoginFormPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Panel izquierdo - Branding (más pequeño)
          Expanded(
            flex: 1,
            child: _buildBrandingPanel(compact: true),
          ),
          // Panel derecho - Login form
          Expanded(
            flex: 1,
            child: _buildLoginFormPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.getHorizontalPadding(context),
              vertical: AppTheme.spacingMD,
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildLoginForm(isMobile: true),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingPanel({bool compact = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            AppTheme.gray900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _GridPatternPainter(),
              ),
            ),
          ),
          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.all(compact ? AppTheme.spacingLG : AppTheme.spacingXXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: compact ? 80 : 120,
                    height: compact ? 80 : 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                      child: Image.asset(
                        'assets/images/logo_colegio.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.school,
                            size: compact ? 48 : 64,
                            color: Theme.of(context).colorScheme.primary,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? AppTheme.spacingLG : AppTheme.spacingXL),
                  Text(
                    'Sistema de Asistencias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: compact ? AppTheme.spacingSM : AppTheme.spacingMD),
                  Text(
                    'Gestión eficiente de asistencias escolares',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: compact ? 14 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!compact) ...[
                    const SizedBox(height: AppTheme.spacingXXL),
                    // Features
                    _buildFeatureItem(
                      icon: Icons.speed,
                      title: 'Rápido y Eficiente',
                      subtitle: 'Registro de asistencias en segundos',
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    _buildFeatureItem(
                      icon: Icons.cloud_sync,
                      title: 'Sincronización',
                      subtitle: 'Datos siempre actualizados',
                    ),
                    const SizedBox(height: AppTheme.spacingMD),
                    _buildFeatureItem(
                      icon: Icons.insights,
                      title: 'Reportes Detallados',
                      subtitle: 'Estadísticas en tiempo real',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: AppTheme.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginFormPanel() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingXXL),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildLoginForm(isMobile: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm({required bool isMobile}) {
    final logoSize = isMobile ? 100.0 : 0.0; // No mostrar logo en desktop/tablet

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMobile) ...[
            // Logo del colegio (solo mobile)
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: logoSize,
                  maxHeight: logoSize,
                ),
                padding: const EdgeInsets.all(AppTheme.spacingSM),
                child: Image.asset(
                  'assets/images/logo_colegio.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: logoSize * 0.7,
                      height: logoSize * 0.7,
                      decoration: BoxDecoration(
                        color: AppTheme.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school,
                        size: logoSize * 0.4,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLG),
            Text(
              'Sistema de Asistencias',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXL),
          ] else ...[
            Text(
              'Iniciar Sesión',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSM),
            Text(
              'Ingrese sus credenciales para acceder',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingXL),
          ],
          // DNI field
          CustomTextField(
            controller: _dniController,
            labelText: 'DNI',
            hintText: 'Ingrese su DNI',
            prefixIcon: Icons.badge,
            keyboardType: TextInputType.number,
            maxLength: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su DNI';
              }
              if (value.length != 8) {
                return 'El DNI debe tener 8 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMD),
          // Password field
          CustomTextField(
            controller: _passwordController,
            labelText: 'Contraseña',
            hintText: 'Ingrese su contraseña',
            prefixIcon: Icons.lock,
            suffixIcon: _obscurePassword
                ? Icons.visibility
                : Icons.visibility_off,
            onSuffixTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMD),
          // Remember me checkbox
          _buildRememberMeCheckbox(),
          const SizedBox(height: AppTheme.spacingLG),
          // Login button
          CustomButton(
            text: 'Iniciar Sesión',
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
          if (!isMobile) ...[
            const SizedBox(height: AppTheme.spacingXL),
            const Divider(),
            const SizedBox(height: AppTheme.spacingMD),
            Text(
              '© ${DateTime.now().year} Sistema de Asistencias',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return InkWell(
      onTap: () {
        setState(() {
          _rememberMe = !_rememberMe;
        });
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSM),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _rememberMe
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _rememberMe
                      ? Theme.of(context).colorScheme.primary
                      : AppTheme.gray400,
                  width: 2,
                ),
              ),
              child: _rememberMe
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: AppTheme.spacingSM),
            Text(
              'Recordar mis credenciales',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for grid pattern
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
