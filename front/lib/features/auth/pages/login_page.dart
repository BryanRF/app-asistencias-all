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

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
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
    final isMobile = Responsive.isMobile(context);
    final logoSize = Responsive.getLogoSize(context);
    final formMaxWidth = Responsive.getLoginFormMaxWidth(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.getHorizontalPadding(context),
              vertical: isMobile ? AppTheme.spacingMD : AppTheme.spacingXL,
            ),
            child: ResponsiveCenter(
              maxWidth: formMaxWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo del colegio
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
                    SizedBox(height: isMobile ? AppTheme.spacingLG : AppTheme.spacingXL),
                    Text(
                      'Sistema de Asistencias',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingSM),
                    Text(
                      'Ingrese sus credenciales',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? AppTheme.spacingXL : AppTheme.spacingXXL),
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
                    // Checkbox Recordarme
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          'Recordarme',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingSM),
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
                    SizedBox(height: isMobile ? AppTheme.spacingLG : AppTheme.spacingXL),
                    CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
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

