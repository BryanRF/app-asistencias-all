import { IAsistenciaRepository } from '../../domain/repositories/asistencia.repository';
import { Asistencia } from '../../domain/entities/asistencia.entity';
export interface GetAsistenciasByHorarioInput {
    horarioId: number;
    fecha: string;
}
export declare class GetAsistenciasByHorarioUseCase {
    private readonly asistenciaRepository;
    constructor(asistenciaRepository: IAsistenciaRepository);
    execute(input: GetAsistenciasByHorarioInput): Promise<Asistencia[]>;
}
