# 🔐 Credenciales de Prueba - Sistema de Asistencias

Este documento contiene las credenciales de prueba para acceder al sistema. **Todas las contraseñas son: `123456`**

---

## 👨‍🏫 Credenciales de Profesores

| # | DNI | Nombres | Apellidos | Email | Contraseña |
|---|-----|---------|-----------|-------|------------|
| 1 | `12345678` | Juan | Pérez García | profesor1@colegio.edu.pe | `123456` |
| 2 | `23456789` | María | González López | profesor2@colegio.edu.pe | `123456` |
| 3 | `34567890` | Carlos | Rodríguez Martínez | profesor3@colegio.edu.pe | `123456` |
| 4 | `45678901` | Ana | Fernández Sánchez | profesor4@colegio.edu.pe | `123456` |
| 5 | `56789012` | Luis | Torres Díaz | profesor5@colegio.edu.pe | `123456` |

### 📝 Ejemplo de uso:
```
DNI: 12345678
Contraseña: 123456
```

---

## 👨‍🎓 Credenciales de Alumnos

Los alumnos se crean automáticamente con el siguiente patrón:

| DNI | Nombres | Apellidos | Email | Contraseña |
|-----|---------|-----------|-------|------------|
| `70000001` | Alumno1 | Apellido1 | alumno1@colegio.edu.pe | `123456` |
| `70000002` | Alumno2 | Apellido2 | alumno2@colegio.edu.pe | `123456` |
| `70000003` | Alumno3 | Apellido3 | alumno3@colegio.edu.pe | `123456` |
| ... | ... | ... | ... | `123456` |
| `70000150` | Alumno150 | Apellido150 | alumno150@colegio.edu.pe | `123456` |

### 📝 Ejemplo de uso:
```
DNI: 70000001
Contraseña: 123456
```

**Nota:** Se crean 150 alumnos (6 secciones × 25 alumnos) con DNI desde `70000001` hasta `70000150`.

---

## 👤 Credenciales de Administrador

| DNI | Nombres | Apellidos | Email | Contraseña |
|-----|---------|-----------|-------|------------|
| `00000000` | Admin | Sistema | admin@colegio.edu.pe | `123456` |

### 📝 Ejemplo de uso:
```
DNI: 00000000
Contraseña: 123456
```

---

## 🔑 Información Importante

- **Todas las contraseñas son:** `123456`
- **Formato de DNI:** 8 dígitos
- **Host por defecto:** `http://192.168.101.11:3000`

---

## 📋 Resumen de Usuarios Creados

- ✅ **5 Profesores** (DNI: 12345678 - 56789012)
- ✅ **150 Alumnos** (DNI: 70000001 - 70000150)
- ✅ **1 Administrador** (DNI: 00000000)

---

## 🚀 Credenciales Recomendadas para Pruebas

### Para probar como Profesor:
```
DNI: 12345678
Contraseña: 123456
```

### Para probar como Alumno:
```
DNI: 70000001
Contraseña: 123456
```

### Para probar como Administrador:
```
DNI: 00000000
Contraseña: 123456
```

---

## ⚠️ Nota de Seguridad

**Estas credenciales son solo para desarrollo y pruebas. En producción, asegúrate de:**
- Cambiar todas las contraseñas por defecto
- Implementar políticas de contraseñas seguras
- Usar autenticación de dos factores si es necesario
- Rotar las contraseñas regularmente

---

**Última actualización:** Diciembre 2024
