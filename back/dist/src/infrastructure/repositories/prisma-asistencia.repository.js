"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PrismaAsistenciaRepository = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
const asistencia_entity_1 = require("../../domain/entities/asistencia.entity");
let PrismaAsistenciaRepository = class PrismaAsistenciaRepository {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(asistencia) {
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
        return asistencia_entity_1.Asistencia.fromPersistence(created);
    }
    async createMany(asistencias) {
        const results = [];
        for (const asistencia of asistencias) {
            const created = await this.create(asistencia);
            results.push(created);
        }
        return results;
    }
    async findById(id) {
        const found = await this.prisma.asistencia.findUnique({
            where: { id },
        });
        if (!found)
            return null;
        return asistencia_entity_1.Asistencia.fromPersistence(found);
    }
    async findByHorarioAndFecha(horarioId, fecha) {
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
        return asistencias.map((a) => asistencia_entity_1.Asistencia.fromPersistence(a));
    }
    async findByUniqueConstraint(fecha, horarioId, alumnoId) {
        const found = await this.prisma.asistencia.findUnique({
            where: {
                fecha_horarioId_alumnoId: {
                    fecha,
                    horarioId,
                    alumnoId,
                },
            },
        });
        if (!found)
            return null;
        return asistencia_entity_1.Asistencia.fromPersistence(found);
    }
    async findAll(pagination, filters) {
        const { page, limit } = pagination;
        const skip = (page - 1) * limit;
        const where = {};
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
            data: data.map((a) => asistencia_entity_1.Asistencia.fromPersistence(a)),
            total,
            page,
            limit,
            totalPages: Math.ceil(total / limit),
        };
    }
    async update(asistencia) {
        const data = asistencia.toPersistence();
        const updated = await this.prisma.asistencia.update({
            where: { id: data.id },
            data: {
                estado: data.estado,
                observacion: data.observacion,
            },
        });
        return asistencia_entity_1.Asistencia.fromPersistence(updated);
    }
    async delete(id) {
        await this.prisma.asistencia.delete({
            where: { id },
        });
    }
};
exports.PrismaAsistenciaRepository = PrismaAsistenciaRepository;
exports.PrismaAsistenciaRepository = PrismaAsistenciaRepository = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], PrismaAsistenciaRepository);
//# sourceMappingURL=prisma-asistencia.repository.js.map