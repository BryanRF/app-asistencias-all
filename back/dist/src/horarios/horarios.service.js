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
exports.HorariosService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let HorariosService = class HorariosService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(createHorarioDto) {
        return this.prisma.horario.create({
            data: createHorarioDto,
            include: {
                curso: true,
                seccion: {
                    include: {
                        grado: true,
                    },
                },
                turno: true,
                profesor: {
                    include: {
                        usuario: true,
                    },
                },
            },
        });
    }
    async findAll(pagination, profesorId, seccionId) {
        const { page = 1, limit = 10 } = pagination;
        const skip = (page - 1) * limit;
        const where = { activo: true };
        if (profesorId) {
            where.profesorId = profesorId;
        }
        if (seccionId) {
            where.seccionId = seccionId;
        }
        const [data, total] = await Promise.all([
            this.prisma.horario.findMany({
                where,
                include: {
                    curso: true,
                    seccion: {
                        include: {
                            grado: true,
                        },
                    },
                    turno: true,
                    profesor: {
                        include: {
                            usuario: true,
                        },
                    },
                },
                skip,
                take: limit,
                orderBy: [
                    { diaSemana: 'asc' },
                    { horaInicio: 'asc' },
                ],
            }),
            this.prisma.horario.count({ where }),
        ]);
        return {
            data,
            total,
            page,
            limit,
            totalPages: Math.ceil(total / limit),
        };
    }
    async findByProfesor(profesorId) {
        const data = await this.prisma.horario.findMany({
            where: {
                profesorId,
                activo: true,
            },
            include: {
                curso: true,
                seccion: {
                    include: {
                        grado: true,
                    },
                },
                turno: true,
            },
            orderBy: [
                { diaSemana: 'asc' },
                { horaInicio: 'asc' },
            ],
        });
        return { data };
    }
    async findOne(id) {
        return this.prisma.horario.findUnique({
            where: { id },
            include: {
                curso: true,
                seccion: {
                    include: {
                        grado: true,
                        alumnos: {
                            where: { activo: true },
                            include: {
                                usuario: true,
                            },
                        },
                    },
                },
                turno: true,
                profesor: {
                    include: {
                        usuario: true,
                    },
                },
            },
        });
    }
    async getAlumnosByHorario(horarioId) {
        const horario = await this.prisma.horario.findUnique({
            where: { id: horarioId },
            include: {
                seccion: {
                    include: {
                        alumnos: {
                            where: { activo: true },
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
                            orderBy: {
                                usuario: {
                                    apellidos: 'asc',
                                },
                            },
                        },
                    },
                },
            },
        });
        return {
            data: horario?.seccion?.alumnos || [],
        };
    }
};
exports.HorariosService = HorariosService;
exports.HorariosService = HorariosService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], HorariosService);
//# sourceMappingURL=horarios.service.js.map