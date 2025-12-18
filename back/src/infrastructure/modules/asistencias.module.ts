import { Module } from '@nestjs/common';
import { PrismaModule } from '../../prisma/prisma.module';

// Presentation
import { AsistenciasController } from '../../presentation/controllers/asistencias.controller';

// Application - Use Cases
import { CreateAsistenciaUseCase } from '../../application/use-cases/create-asistencia.use-case';
import { CreateMultipleAsistenciasUseCase } from '../../application/use-cases/create-multiple-asistencias.use-case';
import { GetAsistenciasUseCase } from '../../application/use-cases/get-asistencias.use-case';
import { GetAsistenciasByHorarioUseCase } from '../../application/use-cases/get-asistencias-by-horario.use-case';

// Infrastructure - Repositories
import { PrismaAsistenciaRepository } from '../repositories/prisma-asistencia.repository';

@Module({
    imports: [PrismaModule],
    controllers: [AsistenciasController],
    providers: [
        // Use Cases
        CreateAsistenciaUseCase,
        CreateMultipleAsistenciasUseCase,
        GetAsistenciasUseCase,
        GetAsistenciasByHorarioUseCase,

        // Repository - Dependency Injection
        {
            provide: 'IAsistenciaRepository',
            useClass: PrismaAsistenciaRepository,
        },
    ],
    exports: [
        'IAsistenciaRepository',
        CreateAsistenciaUseCase,
        CreateMultipleAsistenciasUseCase,
        GetAsistenciasUseCase,
        GetAsistenciasByHorarioUseCase,
    ],
})
export class AsistenciasModule { }
