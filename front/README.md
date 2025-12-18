# Frontend - Sistema de Asistencias

Aplicación móvil desarrollada con Flutter para el sistema de asistencias.

## 🚀 Instalación

1. Instalar dependencias:
```bash
flutter pub get
```

2. Configurar la URL del backend en `lib/core/config/app_config.dart`:
```dart
static const String baseUrl = 'http://tu-ip:3000';
```

## 📱 Ejecutar

```bash
flutter run
```

## 🔐 Credenciales de Prueba

- **Profesor**: DNI: 12345678, Password: 123456
- **Alumno**: DNI: 70000001, Password: 123456

## 📁 Estructura del Proyecto

```
lib/
├── core/
│   ├── config/        # Configuración de la app
│   ├── models/        # Modelos de datos
│   └── services/      # Servicios (API, Auth, etc.)
└── features/
    ├── auth/          # Módulo de autenticación
    └── home/          # Dashboard principal
```
