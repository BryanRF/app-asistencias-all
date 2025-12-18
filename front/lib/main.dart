import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'core/theme/app_theme.dart';
import 'features/auth/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Asistencias',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      // Configuración para web
      builder: (context, child) {
        return MediaQuery(
          // Ajustar el tamaño de fuente para web si es necesario
          data: MediaQuery.of(context).copyWith(
            textScaler: kIsWeb 
                ? const TextScaler.linear(1.0) 
                : MediaQuery.of(context).textScaler,
          ),
          child: child!,
        );
      },
    );
  }
}
