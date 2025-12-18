import { PrismaService } from '../../prisma/prisma.service';
import { IAsistenciaRepository, FindAsistenciasFilters, PaginationOptions, PaginatedResult } from '../../domain/repositories/asistencia.repository';
import { Asistencia } from '../../domain/entities/asistencia.entity';
export declare class PrismaAsistenciaRepository implements IAsistenciaRepository {
    private readonly prisma;
    constructor(prisma: PrismaService);
    create(asistencia: Asistencia): Promise<Asistencia>;
    createMany(asistencias: Asistencia[]): Promise<Asistencia[]>;
    findById(id: number): Promise<Asistencia | null>;
    findByHorarioAndFecha(horarioId: number, fecha: Date): Promise<Asistencia[]>;
    findByUniqueConstraint(fecha: Date, horarioId: number, alumnoId: number): Promise<Asistencia | null>;
    findAll(pagination: PaginationOptions, filters?: FindAsistenciasFilters): Promise<PaginatedResult<Asistencia>>;
    update(asistencia: Asistencia): Promise<Asistencia>;
    delete(id: number): Promise<void>;
}
