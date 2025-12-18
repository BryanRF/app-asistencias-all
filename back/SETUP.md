# Guía de Configuración - Backend

## Pasos para configurar el proyecto

### 1. Instalar dependencias
```bash
npm install
```

### 2. Configurar variables de entorno

Crear archivo `.env` en la raíz de la carpeta `back`:

```env
DATABASE_URL="mysql://usuario:password@localhost:3306/asistencias_db"
JWT_SECRET="tu-secret-key-seguro-aqui"
PORT=3000
```

**Importante**: Reemplazar `usuario`, `password` y `localhost:3306` con tus credenciales reales de MySQL.

### 3. Crear la base de datos

Ejecutar en MySQL:
```sql
CREATE DATABASE asistencias_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 4. Generar el cliente de Prisma

```bash
npx prisma generate
```

### 5. Ejecutar migraciones

```bash
npx prisma migrate dev --name init
```

### 6. Ejecutar seeders

```bash
npm run seed
```

O manualmente:
```bash
npx prisma generate
ts-node prisma/seed.ts
```

### 7. Iniciar el servidor

```bash
npm run start:dev
```

El servidor estará disponible en `http://localhost:3000`

## Solución de problemas

### Error: "Prisma schema validation - url is no longer supported"

✅ **Solucionado**: La URL ahora se configura en `prisma.config.ts`, no en `schema.prisma`.

### Error: "Module '@prisma/client' has no exported member 'PrismaClient'"

**Solución**: Ejecutar primero:
```bash
npx prisma generate
```

Esto genera el cliente de Prisma basado en el schema.

### Error: "Unable to connect to the database"

**Solución**: 
1. Verificar que MySQL esté corriendo
2. Verificar las credenciales en `.env`
3. Verificar que la base de datos `asistencias_db` exista

### Error en seeders con tipos TypeScript

✅ **Solucionado**: Los tipos ahora están explícitamente definidos en el seed.

## Estructura de Prisma 7

En Prisma 7, la configuración cambió:

- **schema.prisma**: Solo define los modelos y el provider (mysql, postgresql, etc.)
- **prisma.config.ts**: Contiene la URL de conexión y configuración de migraciones

Esto permite mayor flexibilidad y mejor separación de configuración.

