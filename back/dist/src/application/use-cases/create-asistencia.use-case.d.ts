import { IAsistenciaRepository } from '../../domain/repositories/asistencia.repository';
import { EstadoAsistencia } from '../../domain/value-objects/estado-asistencia.vo';
export interface CreateAsistenciaInput {
    fecha: string;
    estado: string;
    observacion?: string;
    horarioId: number;
    alumnoId: number;
}
export interface CreateAsistenciaOutput {
    id: number;
    fecha: Date;
    estado: EstadoAsistencia;
    observacion?: string | null;
    horarioId: number;
    alumnoId: number;
}
export declare class CreateAsistenciaUseCase {
    private readonly asistenciaRepository;
    constructor(asistenciaRepository: IAsistenciaRepository);
    execute(input: CreateAsistenciaInput): Promise<CreateAsistenciaOutput>;
}
