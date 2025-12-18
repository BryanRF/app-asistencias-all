import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import {
    IAsistenciaRepository,
    FindAsistenciasFilters,
    PaginationOptions,
    PaginatedResult,
} from '../../domain/repositories/asistencia.repository';
import { Asistencia } from '../../domain/entities/asistencia.entity';
import { EstadoAsistencia } from '../../domain/value-objects/estado-asistencia.vo';

@Injectable()
export class PrismaAsistenciaRepository implements IAsistenciaRepository {
    constructor(private readonly prisma: PrismaService) { }

    async create(asistencia: Asistencia): Promise<Asistencia> {
        const data = asistencia.toPersistence();

        const created = await this.prisma.asistencia.create({
            data: {
                fecha: data.fecha,
                estado: data.estado,
                observacion: data.observacion,
                horarioId: data.horarioId,
                alumnoId: data.alumnoId,
            },
        });

        return Asistencia.fromPersistence(created);
    }

    async createMany(asistencias: Asistencia[]): Promise<Asistencia[]> {
        const results: Asistencia[] = [];

        for (const asistencia of asistencias) {
            const created = await this.create(asistencia);
            results.push(created);
        }

        return results;
    }

    async findById(id: number): Promise<Asistencia | null> {
        const found = await this.prisma.asistencia.findUnique({
            where: { id },
        });

        if (!found) return null;

        return Asistencia.fromPersistence(found);
    }

    async findByHorarioAndFecha(horarioId: number, fecha: Date): Promise<Asistencia[]> {
        const asistencias = await this.prisma.asistencia.findMany({
            where: {
                horarioId,
                fecha,
            },
            include: {
                alumno: {
                    include: {
                        usuario: {
                            select: {
                                id: true,
                                dni: true,
                                nombres: true,
                                apellidos: true,
                            },
                        },
                    },
                },
            },
            orderBy: {
                alumno: {
                    usuario: {
                        apellidos: 'asc',
                    },
                },
            },
        });

        return asistencias.map((a) => Asistencia.fromPersistence(a));
    }

    async findByUniqueConstraint(
        fecha: Date,
        horarioId: number,
        alumnoId: number,
    ): Promise<Asistencia | null> {
        const found = await this.prisma.asistencia.findUnique({
            where: {
                fecha_horarioId_alumnoId: {
                    fecha,
                    horarioId,
                    alumnoId,
                },
            },
        });

        if (!found) return null;

        return Asistencia.fromPersistence(found);
    }

    async findAll(
        pagination: PaginationOptions,
        filters?: FindAsistenciasFilters,
    ): Promise<PaginatedResult<Asistencia>> {
        const { page, limit } = pagination;
        const skip = (page - 1) * limit;

        const where: any = {};

        if (filters?.fechaInicio || filters?.fechaFin) {
            where.fecha = {};
            if (filters.fechaInicio) {
                where.fecha.gte = filters.fechaInicio;
            }
            if (filters.fechaFin) {
                where.fecha.lte = filters.fechaFin;
            }
        }

        if (filters?.horarioId) {
            where.horarioId = filters.horarioId;
        }

        if (filters?.alumnoId) {
            where.alumnoId = filters.alumnoId;
        }

        if (filters?.seccionId) {
            where.alumno = {
                seccionId: filters.seccionId,
            };
        }

        const [data, total] = await Promise.all([
            this.prisma.asistencia.findMany({
                where,
                include: {
                    horario: {
                        include: {
                            curso: true,
                            seccion: {
                                include: {
                                    grado: true,
                                },
                            },
                        },
                    },
                    alumno: {
                        include: {
                            usuario: {
                                select: {
                                    id: true,
                                    dni: true,
                                    nombres: true,
                                    apellidos: true,
                                },
                            },
                        },
                    },
                },
                skip,
                take: limit,
                orderBy: { fecha: 'desc' },
            }),
            this.prisma.asistencia.count({ where }),
        ]);

        return {
            data: data.map((a) => Asistencia.fromPersistence(a)),
            total,
            page,
            limit,
            totalPages: Math.ceil(total / limit),
        };
    }

    async update(asistencia: Asistencia): Promise<Asistencia> {
        const data = asistencia.toPersistence();

        const updated = await this.prisma.asistencia.update({
            where: { id: data.id },
            data: {
                estado: data.estado,
                observacion: data.observacion,
            },
        });

        return Asistencia.fromPersistence(updated);
    }

    async delete(id: number): Promise<void> {
        await this.prisma.asistencia.delete({
            where: { id },
        });
    }
}
