import { Injectable, Inject } from '@nestjs/common';
import { IAsistenciaRepository } from '../../domain/repositories/asistencia.repository';
import { Asistencia } from '../../domain/entities/asistencia.entity';

export interface GetAsistenciasByHorarioInput {
    horarioId: number;
    fecha: string;
}

@Injectable()
export class GetAsistenciasByHorarioUseCase {
    constructor(
        @Inject('IAsistenciaRepository')
        private readonly asistenciaRepository: IAsistenciaRepository,
    ) { }

    async execute(input: GetAsistenciasByHorarioInput): Promise<Asistencia[]> {
        const fecha = new Date(input.fecha);
        return this.asistenciaRepository.findByHorarioAndFecha(input.horarioId, fecha);
    }
}
