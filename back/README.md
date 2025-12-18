# Backend - Sistema de Asistencias

Backend desarrollado con NestJS, Prisma y MySQL siguiendo Clean Architecture.

## 🚀 Instalación

1. Instalar dependencias:
```bash
npm install
```

2. Configurar variables de entorno:
```bash
cp .env.example .env
```

Editar `.env` con tus credenciales de MySQL:
```
DATABASE_URL="mysql://usuario:password@localhost:3306/asistencias_db"
JWT_SECRET="tu-secret-key-seguro"
PORT=3000
```

3. Crear la base de datos:
```bash
npx prisma migrate dev --name init
```

4. Ejecutar seeders:
```bash
npm run seed
```

## 📝 Scripts Disponibles

- `npm run start:dev` - Inicia el servidor en modo desarrollo
- `npm run build` - Compila el proyecto
- `npm run start:prod` - Inicia el servidor en modo producción
- `npm run seed` - Ejecuta los seeders para poblar la base de datos

## 🔐 Credenciales de Prueba

Después de ejecutar los seeders, puedes usar:

- **Admin**: DNI: 00000000, Password: 123456
- **Profesor**: DNI: 12345678, Password: 123456
- **Alumno**: DNI: 70000001, Password: 123456

## 📚 Endpoints Principales

- `POST /auth/login` - Login con DNI y contraseña
- `GET /grados` - Listar grados (paginado)
- `GET /secciones` - Listar secciones (paginado)
- `GET /cursos` - Listar cursos (paginado)
- `GET /horarios` - Listar horarios (paginado)
- `POST /asistencias` - Crear asistencia
- `POST /asistencias/multiple` - Crear múltiples asistencias
- `GET /reportes/alumno/:id` - Reporte por alumno
- `GET /reportes/seccion/:id` - Reporte por sección

## 🔌 WebSocket

El servidor WebSocket está disponible en el mismo puerto. Eventos disponibles:

- `join-horario` - Unirse a un horario
- `registrar-asistencias` - Registrar asistencias en tiempo real
- `obtener-asistencias` - Obtener asistencias de un horario y fecha
