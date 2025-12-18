import { Injectable, Inject, BadRequestException } from '@nestjs/common';
import { IAsistenciaRepository } from '../../domain/repositories/asistencia.repository';
import { Asistencia } from '../../domain/entities/asistencia.entity';
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

@Injectable()
export class CreateAsistenciaUseCase {
    constructor(
        @Inject('IAsistenciaRepository')
        private readonly asistenciaRepository: IAsistenciaRepository,
    ) { }

    async execute(input: CreateAsistenciaInput): Promise<CreateAsistenciaOutput> {
        const fecha = new Date(input.fecha);
        const estado = input.estado as EstadoAsistencia;

        // Verificar si ya existe (regla de negocio)
        const existente = await this.asistenciaRepository.findByUniqueConstraint(
            fecha,
            input.horarioId,
            input.alumnoId,
        );

        if (existente) {
            throw new BadRequestException(
                'Ya existe una asistencia registrada para este alumno en esta fecha y horario',
            );
        }

        // Crear entidad de dominio
        const asistencia = Asistencia.create({
            fecha,
            estado,
            observacion: input.observacion,
            horarioId: input.horarioId,
            alumnoId: input.alumnoId,
        });

        // Persistir
        const saved = await this.asistenciaRepository.create(asistencia);

        return {
            id: saved.id!,
            fecha: saved.fecha,
            estado: saved.estado,
            observacion: saved.observacion,
            horarioId: saved.horarioId,
            alumnoId: saved.alumnoId,
        };
    }
}
