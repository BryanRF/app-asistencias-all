# Clean Architecture - Backend

Esta guía documenta la arquitectura limpia implementada en el backend siguiendo los principios **SOLID**.

## 📁 Estructura de Carpetas

```
src/
├── domain/                    # 🔵 CAPA DE DOMINIO (Reglas de negocio)
│   ├── entities/             # Entidades con lógica de negocio
│   ├── value-objects/        # Objetos de valor inmutables
│   └── repositories/         # Interfaces abstractas (contratos)
│
├── application/               # 🟢 CAPA DE APLICACIÓN (Casos de uso)
│   └── use-cases/            # Casos de uso (un archivo por caso)
│
├── infrastructure/            # 🟠 CAPA DE INFRAESTRUCTURA
│   ├── repositories/         # Implementaciones de repositorios (Prisma)
│   └── modules/              # Módulos de NestJS con DI configurada
│
├── presentation/              # 🟣 CAPA DE PRESENTACIÓN
│   └── controllers/          # Controllers HTTP (thin controllers)
│       └── dto/              # DTOs para validación de entrada
│
└── common/                    # Código compartido
    ├── guards/
    ├── filters/
    ├── decorators/
    └── strategies/
```

## 🎯 Principios SOLID Aplicados

### S - Single Responsibility Principle (SRP)
- Cada **Use Case** tiene una única responsabilidad
- Ejemplo: `CreateAsistenciaUseCase` solo crea asistencias

### O - Open/Closed Principle (OCP)
- Las entidades están abiertas a extensión pero cerradas a modificación
- Nuevos comportamientos se agregan sin modificar código existente

### L - Liskov Substitution Principle (LSP)
- Las implementaciones de repositorios pueden sustituirse sin afectar el sistema
- `PrismaAsistenciaRepository` puede reemplazarse por `MongoAsistenciaRepository`

### I - Interface Segregation Principle (ISP)
- Interfaces pequeñas y específicas
- `IAsistenciaRepository` solo define métodos relacionados con asistencias

### D - Dependency Inversion Principle (DIP)
- Las capas superiores dependen de abstracciones, no de implementaciones
- Los Use Cases dependen de `IAsistenciaRepository`, no de `PrismaAsistenciaRepository`

## 🔄 Flujo de Datos

```
HTTP Request
    │
    ▼
┌─────────────────┐
│   Controller    │  ← Recibe petición, valida DTOs
│  (Presentation) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Use Case     │  ← Ejecuta lógica de negocio
│  (Application)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Repository    │  ← Abstracción (Interface)
│    (Domain)     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ PrismaRepository│  ← Implementación concreta
│(Infrastructure) │
└────────┬────────┘
         │
         ▼
    Base de Datos
```

## 📝 Ejemplo de Implementación

### 1. Entidad de Dominio
```typescript
// domain/entities/asistencia.entity.ts
export class Asistencia {
  static create(props: AsistenciaProps): Asistencia {
    // Validaciones de dominio
    if (!props.fecha) throw new Error('La fecha es requerida');
    return new Asistencia(props);
  }
}
```

### 2. Repositorio (Contrato)
```typescript
// domain/repositories/asistencia.repository.ts
export abstract class IAsistenciaRepository {
  abstract create(asistencia: Asistencia): Promise<Asistencia>;
  abstract findById(id: number): Promise<Asistencia | null>;
}
```

### 3. Caso de Uso
```typescript
// application/use-cases/create-asistencia.use-case.ts
@Injectable()
export class CreateAsistenciaUseCase {
  constructor(
    @Inject('IAsistenciaRepository')
    private readonly repo: IAsistenciaRepository,
  ) {}

  async execute(input: CreateAsistenciaInput): Promise<Asistencia> {
    const asistencia = Asistencia.create(input);
    return this.repo.create(asistencia);
  }
}
```

### 4. Implementación del Repositorio
```typescript
// infrastructure/repositories/prisma-asistencia.repository.ts
@Injectable()
export class PrismaAsistenciaRepository implements IAsistenciaRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(asistencia: Asistencia): Promise<Asistencia> {
    const data = asistencia.toPersistence();
    const created = await this.prisma.asistencia.create({ data });
    return Asistencia.fromPersistence(created);
  }
}
```

### 5. Controller (Thin)
```typescript
// presentation/controllers/asistencias.controller.ts
@Controller('asistencias')
export class AsistenciasController {
  constructor(private readonly createUseCase: CreateAsistenciaUseCase) {}

  @Post()
  create(@Body() dto: CreateAsistenciaDto) {
    return this.createUseCase.execute(dto);
  }
}
```

### 6. Módulo con DI
```typescript
// infrastructure/modules/asistencias.module.ts
@Module({
  providers: [
    CreateAsistenciaUseCase,
    {
      provide: 'IAsistenciaRepository',
      useClass: PrismaAsistenciaRepository,
    },
  ],
})
export class AsistenciasModule {}
```

## ✅ Beneficios

1. **Testeable**: Fácil de mockear dependencias
2. **Mantenible**: Cambios aislados por capa
3. **Escalable**: Agregar funcionalidad sin modificar código existente
4. **Desacoplado**: Cambiar de Prisma a otro ORM es sencillo
5. **Legible**: Código organizado y predecible

## 🔧 Migración Gradual

Los módulos legacy (grados, secciones, cursos, etc.) pueden migrarse gradualmente
siguiendo el mismo patrón. El `AppModule` soporta ambos estilos durante la transición.
