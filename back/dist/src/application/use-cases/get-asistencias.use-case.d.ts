import { IAsistenciaRepository, PaginatedResult } from '../../domain/repositories/asistencia.repository';
import { Asistencia } from '../../domain/entities/asistencia.entity';
export interface GetAsistenciasInput {
    page?: number;
    limit?: number;
    fechaInicio?: string;
    fechaFin?: string;
    horarioId?: number;
    alumnoId?: number;
    seccionId?: number;
}
export declare class GetAsistenciasUseCase {
    private readonly asistenciaRepository;
    constructor(asistenciaRepository: IAsistenciaRepository);
    execute(input: GetAsistenciasInput): Promise<PaginatedResult<Asistencia>>;
}
