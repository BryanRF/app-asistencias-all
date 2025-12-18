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
exports.ReportesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let ReportesService = class ReportesService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async reportePorAlumno(alumnoId, fechaInicio, fechaFin) {
        const where = { alumnoId };
        if (fechaInicio || fechaFin) {
            where.fecha = {};
            if (fechaInicio) {
                where.fecha.gte = new Date(fechaInicio);
            }
            if (fechaFin) {
                where.fecha.lte = new Date(fechaFin);
            }
        }
        const asistencias = await this.prisma.asistencia.findMany({
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
            },
            orderBy: { fecha: 'desc' },
        });
        const resumen = {
            total: asistencias.length,
            presentes: asistencias.filter(a => a.estado === 'PRESENTE').length,
            tardanzas: asistencias.filter(a => a.estado === 'TARDANZA').length,
            faltas: asistencias.filter(a => a.estado === 'FALTA').length,
            justificadas: asistencias.filter(a => a.estado === 'JUSTIFICADA').length,
        };
        return {
            resumen,
            asistencias,
        };
    }
    async reportePorSeccion(seccionId, fechaInicio, fechaFin) {
        const where = {
            alumno: {
                seccionId,
            },
        };
        if (fechaInicio || fechaFin) {
            where.fecha = {};
            if (fechaInicio) {
                where.fecha.gte = new Date(fechaInicio);
            }
            if (fechaFin) {
                where.fecha.lte = new Date(fechaFin);
            }
        }
        const asistencias = await this.prisma.asistencia.findMany({
            where,
            include: {
                alumno: {
                    include: {
                        usuario: true,
                    },
                },
                horario: {
                    include: {
                        curso: true,
                    },
                },
            },
            orderBy: [
                { fecha: 'desc' },
                { alumno: { usuario: { apellidos: 'asc' } } },
            ],
        });
        const porAlumno = asistencias.reduce((acc, asistencia) => {
            const alumnoId = asistencia.alumnoId;
            if (!acc[alumnoId]) {
                acc[alumnoId] = {
                    alumno: asistencia.alumno,
                    asistencias: [],
                    resumen: {
                        total: 0,
                        presentes: 0,
                        tardanzas: 0,
                        faltas: 0,
                        justificadas: 0,
                    },
                };
            }
            acc[alumnoId].asistencias.push(asistencia);
            acc[alumnoId].resumen.total++;
            if (asistencia.estado === 'PRESENTE')
                acc[alumnoId].resumen.presentes++;
            if (asistencia.estado === 'TARDANZA')
                acc[alumnoId].resumen.tardanzas++;
            if (asistencia.estado === 'FALTA')
                acc[alumnoId].resumen.faltas++;
            if (asistencia.estado === 'JUSTIFICADA')
                acc[alumnoId].resumen.justificadas++;
            return acc;
        }, {});
        return {
            seccionId,
            totalAlumnos: Object.keys(porAlumno).length,
            porAlumno: Object.values(porAlumno),
        };
    }
    async reportePorCurso(cursoId, fechaInicio, fechaFin) {
        const where = {
            horario: {
                cursoId,
            },
        };
        if (fechaInicio || fechaFin) {
            where.fecha = {};
            if (fechaInicio) {
                where.fecha.gte = new Date(fechaInicio);
            }
            if (fechaFin) {
                where.fecha.lte = new Date(fechaFin);
            }
        }
        const asistencias = await this.prisma.asistencia.findMany({
            where,
            include: {
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
                horario: {
                    include: {
                        seccion: true,
                    },
                },
            },
            orderBy: [
                { fecha: 'desc' },
                { alumno: { usuario: { apellidos: 'asc' } } },
            ],
        });
        const resumen = {
            total: asistencias.length,
            presentes: asistencias.filter(a => a.estado === 'PRESENTE').length,
            tardanzas: asistencias.filter(a => a.estado === 'TARDANZA').length,
            faltas: asistencias.filter(a => a.estado === 'FALTA').length,
            justificadas: asistencias.filter(a => a.estado === 'JUSTIFICADA').length,
        };
        return {
            cursoId,
            resumen,
            asistencias,
        };
    }
};
exports.ReportesService = ReportesService;
exports.ReportesService = ReportesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ReportesService);
//# sourceMappingURL=reportes.service.js.map