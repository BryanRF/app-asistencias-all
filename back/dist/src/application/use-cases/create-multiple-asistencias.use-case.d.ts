import { IAsistenciaRepository } from '../../domain/repositories/asistencia.repository';
export interface AsistenciaItemInput {
    alumnoId: number;
    estado: string;
    observacion?: string;
}
export interface CreateMultipleAsistenciasInput {
    fecha: string;
    horarioId: number;
    asistencias: AsistenciaItemInput[];
}
export interface CreateMultipleAsistenciasOutput {
    creadas: number;
    errores: {
        alumnoId: number;
        error: string;
    }[];
    total: number;
}
export declare class CreateMultipleAsistenciasUseCase {
    private readonly asistenciaRepository;
    constructor(asistenciaRepository: IAsistenciaRepository);
    execute(input: CreateMultipleAsistenciasInput): Promise<CreateMultipleAsistenciasOutput>;
}
