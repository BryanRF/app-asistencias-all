import { Module } from '@nestjs/common';
import { APP_FILTER, APP_GUARD, APP_PIPE } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigModule } from './config/config.module';
import { PrismaModule } from './prisma/prisma.module';

// Clean Architecture Modules
import { AuthModule } from './infrastructure/modules/auth.module';
import { AsistenciasModule } from './infrastructure/modules/asistencias.module';

// Legacy Modules (para mantener compatibilidad mientras se migran)
import { GradosModule } from './grados/grados.module';
import { SeccionesModule } from './secciones/secciones.module';
import { TurnosModule } from './turnos/turnos.module';
import { CursosModule } from './cursos/cursos.module';
import { HorariosModule } from './horarios/horarios.module';
import { ReportesModule } from './reportes/reportes.module';

// Common
import { JwtAuthGuard } from './common/guards/jwt-auth.guard';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,

    // Clean Architecture Modules
    AuthModule,
    AsistenciasModule,

    // Legacy Modules
    GradosModule,
    SeccionesModule,
    TurnosModule,
    CursosModule,
    HorariosModule,
    ReportesModule,
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
    {
      provide: APP_FILTER,
      useClass: HttpExceptionFilter,
    },
    {
      provide: APP_PIPE,
      useClass: ValidationPipe,
    },
  ],
})
export class AppModule { }
