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
exports.AsistenciasService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let AsistenciasService = class AsistenciasService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(createAsistenciaDto) {
        const fecha = new Date(createAsistenciaDto.fecha);
        const existe = await this.prisma.asistencia.findUnique({
            where: {
                fecha_horarioId_alumnoId: {
                    fecha: fecha,
                    horarioId: createAsistenciaDto.horarioId,
                    alumnoId: createAsistenciaDto.alumnoId,
                },
            },
        });
        if (existe) {
            throw new common_1.BadRequestException('Ya existe una asistencia registrada para este alumno en esta fecha y horario');
        }
        return this.prisma.asistencia.create({
            data: {
                fecha: fecha,
                estado: createAsistenciaDto.estado,
                observacion: createAsistenciaDto.observacion,
                horarioId: createAsistenciaDto.horarioId,
                alumnoId: createAsistenciaDto.alumnoId,
            },
            include: {
                horario: {
                    include: {
                        curso: true,
                        seccion: {
                            include: {
                                grado: true,
                            },
                        },
                        profesor: {
                            include: {
                                usuario: true,
                            },
                        },
                    },
                },
                alumno: {
                    include: {
                        usuario: true,
                        seccion: true,
                    },
                },
            },
        });
    }
    async createMultiple(createMultipleDto) {
        const fecha = new Date(createMultipleDto.fecha);
        const horario = await this.prisma.horario.findUnique({
            where: { id: createMultipleDto.horarioId },
        });
        if (!horario) {
            throw new common_1.BadRequestException('Horario no encontrado');
        }
        const resultados = [];
        const errores = [];
        for (const asistencia of createMultipleDto.asistencias) {
            try {
                const existe = await this.prisma.asistencia.findUnique({
                    where: {
                        fecha_horarioId_alumnoId: {
                            fecha: fecha,
                            horarioId: createMultipleDto.horarioId,
                            alumnoId: asistencia.alumnoId,
                        },
                    },
                });
                if (existe) {
                    errores.push({
                        alumnoId: asistencia.alumnoId,
                        error: 'Ya existe una asistencia registrada',
                    });
                    continue;
                }
                const creada = await this.prisma.asistencia.create({
                    data: {
                        fecha: fecha,
                        estado: asistencia.estado,
                        observacion: asistencia.observacion,
                        horarioId: createMultipleDto.horarioId,
                        alumnoId: asistencia.alumnoId,
                    },
                    include: {
                        alumno: {
                            include: {
                                usuario: true,
                            },
                        },
                    },
                });
                resultados.push(creada);
            }
            catch (error) {
                errores.push({
                    alumnoId: asistencia.alumnoId,
                    error: error.message,
                });
            }
        }
        return {
            creadas: resultados,
            errores,
            total: resultados.length,
        };
    }
    async findAll(pagination, filters) {
        const { page = 1, limit = 10 } = pagination;
        const skip = (page - 1) * limit;
        const where = {};
        if (filters?.fechaInicio || filters?.fechaFin) {
            where.fecha = {};
            if (filters.fechaInicio) {
                where.fecha.gte = new Date(filters.fechaInicio);
            }
            if (filters.fechaFin) {
                where.fecha.lte = new Date(filters.fechaFin);
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
                            profesor: {
                                include: {
                                    usuario: true,
                                },
                            },
                        },
                    },
                    alumno: {
                        include: {
                            usuario: true,
                            seccion: {
                                include: {
                                    grado: true,
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
            data,
            total,
            page,
            limit,
            totalPages: Math.ceil(total / limit),
        };
    }
    async findOne(id) {
        return this.prisma.asistencia.findUnique({
            where: { id },
            include: {
                horario: {
                    include: {
                        curso: true,
                        seccion: {
                            include: {
                                grado: true,
                            },
                        },
                        profesor: {
                            include: {
                                usuario: true,
                            },
                        },
                    },
                },
                alumno: {
                    include: {
                        usuario: true,
                        seccion: {
                            include: {
                                grado: true,
                            },
                        },
                    },
                },
            },
        });
    }
    async getByHorarioAndFecha(horarioId, fecha) {
        const fechaDate = new Date(fecha);
        return this.prisma.asistencia.findMany({
            where: {
                horarioId,
                fecha: fechaDate,
            },
            include: {
                alumno: {
                    include: {
                        usuario: true,
                        seccion: true,
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
    }
};
exports.AsistenciasService = AsistenciasService;
exports.AsistenciasService = AsistenciasService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AsistenciasService);
//# sourceMappingURL=asistencias.service.js.map