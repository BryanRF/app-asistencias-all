# Sistema de Asistencias Escolar

Sistema completo de registro de asistencias para colegios de Perú (Primaria y Secundaria), desarrollado con NestJS (backend) y Flutter (frontend móvil).

## 📁 Estructura del Proyecto

```
app-asistencias-all/
├── back/          # Backend NestJS + Prisma + MySQL
└── front/         # Frontend Flutter
```

## 🚀 Inicio Rápido

### Backend

1. **Navegar a la carpeta back:**
```bash
cd back
```

2. **Instalar dependencias:**
```bash
npm install
```

3. **Configurar base de datos:**
   - Crear base de datos MySQL: `asistencias_db`
   - Copiar `.env.example` a `.env` y configurar:
   ```
   DATABASE_URL="mysql://usuario:password@localhost:3306/asistencias_db"
   JWT_SECRET="tu-secret-key-seguro"
   PORT=3000
   ```

4. **Ejecutar migraciones:**
```bash
npx prisma migrate dev --name init
```

5. **Poblar base de datos con seeders:**
```bash
npm run seed
```

6. **Iniciar servidor:**
```bash
npm run start:dev
```

El servidor estará disponible en `http://localhost:3000`

### Frontend

1. **Navegar a la carpeta front:**
```bash
cd front
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Configurar URL del backend** en `lib/core/config/app_config.dart`:
```dart
static const String baseUrl = 'http://TU_IP:3000';  // Cambiar localhost por tu IP
```

4. **Ejecutar aplicación:**
```bash
flutter run
```

## 🔐 Credenciales de Prueba

Después de ejecutar los seeders, puedes usar:

- **Admin**: DNI: `00000000`, Password: `123456`
- **Profesor**: DNI: `12345678`, Password: `123456`
- **Alumno**: DNI: `70000001`, Password: `123456`

## 📋 Características

### Backend (NestJS)
- ✅ Clean Architecture
- ✅ Autenticación JWT (login con DNI)
- ✅ Roles: Alumno, Profesor, Admin
- ✅ Módulos: Grados, Secciones, Turnos, Cursos, Horarios
- ✅ Registro de asistencias (individual y múltiple)
- ✅ WebSocket para registro en tiempo real
- ✅ Reportes de asistencias (por alumno, sección, curso)
- ✅ Paginación en todos los endpoints
- ✅ Seeders completos con datos de prueba

### Frontend (Flutter)
- ✅ Login con DNI y contraseña
- ✅ Dashboard diferenciado por rol (Alumno/Profesor)
- ✅ Arquitectura limpia y escalable
- ✅ Servicios para API REST
- ✅ Preparado para WebSocket

## 📚 Endpoints Principales

### Autenticación
- `POST /auth/login` - Login con DNI y contraseña

### Académicos
- `GET /grados` - Listar grados (paginado)
- `GET /secciones` - Listar secciones (paginado)
- `GET /turnos` - Listar turnos (paginado)
- `GET /cursos` - Listar cursos (paginado)
- `GET /horarios` - Listar horarios (paginado)

### Asistencias
- `POST /asistencias` - Crear asistencia individual
- `POST /asistencias/multiple` - Crear múltiples asistencias
- `GET /asistencias` - Listar asistencias (paginado, con filtros)
- `GET /asistencias/horario/:horarioId/fecha/:fecha` - Obtener asistencias por horario y fecha

### Reportes
- `GET /reportes/alumno/:id` - Reporte de asistencias por alumno
- `GET /reportes/seccion/:id` - Reporte de asistencias por sección
- `GET /reportes/curso/:id` - Reporte de asistencias por curso

## 🔌 WebSocket

El servidor WebSocket está disponible en el mismo puerto. Eventos:

- `join-horario` - Unirse a un horario específico
- `leave-horario` - Salir de un horario
- `registrar-asistencias` - Registrar asistencias en tiempo real
- `obtener-asistencias` - Obtener asistencias de un horario y fecha

## 🏗️ Arquitectura

### Backend
```
src/
├── common/          # Componentes compartidos (guards, decorators, filters, DTOs)
├── config/          # Configuración
├── prisma/          # Servicio Prisma
├── auth/            # Módulo de autenticación
├── grados/          # Módulo de grados
├── secciones/       # Módulo de secciones
├── turnos/          # Módulo de turnos
├── cursos/          # Módulo de cursos
├── horarios/        # Módulo de horarios
├── asistencias/     # Módulo de asistencias (con WebSocket)
└── reportes/        # Módulo de reportes
```

### Frontend
```
lib/
├── core/
│   ├── config/      # Configuración
│   ├── models/      # Modelos de datos
│   └── services/   # Servicios (API, Auth)
└── features/
    ├── auth/        # Módulo de autenticación
    └── home/        # Dashboard principal
```

## 📝 Notas

- El sistema está diseñado para funcionar como un colegio real de Perú
- Soporta Primaria (1° a 6°) y Secundaria (1° a 5°)
- Los seeders crean datos de prueba completos
- Todas las listas están paginadas
- El código sigue principios SOLID y Clean Architecture

## 🛠️ Tecnologías

- **Backend**: NestJS, Prisma, MySQL, Socket.io, JWT, bcrypt
- **Frontend**: Flutter, HTTP, Socket.io Client, Provider, SharedPreferences

## 📄 Licencia

Este proyecto es privado y de uso educativo.

