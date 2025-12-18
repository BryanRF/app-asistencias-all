import { Asistencia } from '../entities/asistencia.entity';

export interface FindAsistenciasFilters {
    fechaInicio?: Date;
    fechaFin?: Date;
    horarioId?: number;
    alumnoId?: number;
    seccionId?: number;
}

export interface PaginationOptions {
    page: number;
    limit: number;
}

export interface PaginatedResult<T> {
    data: T[];
    total: number;
    page: number;
    limit: number;
    totalPages: number;
}

// Interface del repositorio - Inversión de Dependencias (DIP)
export abstract class IAsistenciaRepository {
    abstract create(asistencia: Asistencia): Promise<Asistencia>;
    abstract createMany(asistencias: Asistencia[]): Promise<Asistencia[]>;
    abstract findById(id: number): Promise<Asistencia | null>;
    abstract findByHorarioAndFecha(horarioId: number, fecha: Date): Promise<Asistencia[]>;
    abstract findByUniqueConstraint(
        fecha: Date,
        horarioId: number,
        alumnoId: number,
    ): Promise<Asistencia | null>;
    abstract findAll(
        pagination: PaginationOptions,
        filters?: FindAsistenciasFilters,
    ): Promise<PaginatedResult<Asistencia>>;
    abstract update(asistencia: Asistencia): Promise<Asistencia>;
    abstract delete(id: number): Promise<void>;
}
