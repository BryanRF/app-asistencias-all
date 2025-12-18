import { Injectable, Inject, BadRequestException } from '@nestjs/common';
import { IAsistenciaRepository } from '../../domain/repositories/asistencia.repository';
import { Asistencia } from '../../domain/entities/asistencia.entity';
import { EstadoAsistencia } from '../../domain/value-objects/estado-asistencia.vo';

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
    errores: { alumnoId: number; error: string }[];
    total: number;
}

@Injectable()
export class CreateMultipleAsistenciasUseCase {
    constructor(
        @Inject('IAsistenciaRepository')
        private readonly asistenciaRepository: IAsistenciaRepository,
    ) { }

    async execute(input: CreateMultipleAsistenciasInput): Promise<CreateMultipleAsistenciasOutput> {
        const fecha = new Date(input.fecha);
        const asistenciasCreadas: Asistencia[] = [];
        const errores: { alumnoId: number; error: string }[] = [];

        for (const item of input.asistencias) {
            try {
                // Verificar si ya existe
                const existente = await this.asistenciaRepository.findByUniqueConstraint(
                    fecha,
                    input.horarioId,
                    item.alumnoId,
                );

                if (existente) {
                    errores.push({
                        alumnoId: item.alumnoId,
                        error: 'Ya existe una asistencia registrada',
                    });
                    continue;
                }

                // Crear entidad de dominio
                const asistencia = Asistencia.create({
                    fecha,
                    estado: item.estado as EstadoAsistencia,
                    observacion: item.observacion,
                    horarioId: input.horarioId,
                    alumnoId: item.alumnoId,
                });

                const saved = await this.asistenciaRepository.create(asistencia);
                asistenciasCreadas.push(saved);
            } catch (error) {
                errores.push({
                    alumnoId: item.alumnoId,
                    error: error instanceof Error ? error.message : 'Error desconocido',
                });
            }
        }

        return {
            creadas: asistenciasCreadas.length,
            errores,
            total: input.asistencias.length,
        };
    }
}
