import { CreateAsistenciaUseCase } from '../../application/use-cases/create-asistencia.use-case';
import { CreateMultipleAsistenciasUseCase } from '../../application/use-cases/create-multiple-asistencias.use-case';
import { GetAsistenciasUseCase } from '../../application/use-cases/get-asistencias.use-case';
import { GetAsistenciasByHorarioUseCase } from '../../application/use-cases/get-asistencias-by-horario.use-case';
import { CreateAsistenciaDto, CreateMultipleAsistenciaDto } from './dto/create-asistencia.dto';
import { PaginationDto } from '../../common/dto/pagination.dto';
export declare class AsistenciasController {
    private readonly createAsistenciaUseCase;
    private readonly createMultipleAsistenciasUseCase;
    private readonly getAsistenciasUseCase;
    private readonly getAsistenciasByHorarioUseCase;
    constructor(createAsistenciaUseCase: CreateAsistenciaUseCase, createMultipleAsistenciasUseCase: CreateMultipleAsistenciasUseCase, getAsistenciasUseCase: GetAsistenciasUseCase, getAsistenciasByHorarioUseCase: GetAsistenciasByHorarioUseCase);
    create(createAsistenciaDto: CreateAsistenciaDto): Promise<import("../../application/use-cases/create-asistencia.use-case").CreateAsistenciaOutput>;
    createMultiple(createMultipleDto: CreateMultipleAsistenciaDto): Promise<import("../../application/use-cases/create-multiple-asistencias.use-case").CreateMultipleAsistenciasOutput>;
    findAll(pagination: PaginationDto, fechaInicio?: string, fechaFin?: string, horarioId?: number, alumnoId?: number, seccionId?: number, req?: any): Promise<import("../../domain/repositories").PaginatedResult<import("../../domain/entities").Asistencia>>;
    getByHorarioAndFecha(horarioId: number, fecha: string): Promise<import("../../domain/entities").Asistencia[]>;
}
