import { Injectable, Inject } from '@nestjs/common';
import {
    IAsistenciaRepository,
    FindAsistenciasFilters,
    PaginatedResult,
} from '../../domain/repositories/asistencia.repository';
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

@Injectable()
export class GetAsistenciasUseCase {
    constructor(
        @Inject('IAsistenciaRepository')
        private readonly asistenciaRepository: IAsistenciaRepository,
    ) { }

    async execute(input: GetAsistenciasInput): Promise<PaginatedResult<Asistencia>> {
        const pagination = {
            page: input.page || 1,
            limit: input.limit || 10,
        };

        const filters: FindAsistenciasFilters = {};

        if (input.fechaInicio) {
            filters.fechaInicio = new Date(input.fechaInicio);
        }
        if (input.fechaFin) {
            filters.fechaFin = new Date(input.fechaFin);
        }
        if (input.horarioId) {
            filters.horarioId = input.horarioId;
        }
        if (input.alumnoId) {
            filters.alumnoId = input.alumnoId;
        }
        if (input.seccionId) {
            filters.seccionId = input.seccionId;
        }

        return this.asistenciaRepository.findAll(pagination, filters);
    }
}
