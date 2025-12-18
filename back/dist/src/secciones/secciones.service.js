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
exports.SeccionesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let SeccionesService = class SeccionesService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(createSeccionDto) {
        return this.prisma.seccion.create({
            data: createSeccionDto,
            include: {
                grado: true,
            },
        });
    }
    async findAll(pagination, gradoId) {
        const { page = 1, limit = 10 } = pagination;
        const skip = (page - 1) * limit;
        const where = { activo: true };
        if (gradoId) {
            where.gradoId = gradoId;
        }
        const [data, total] = await Promise.all([
            this.prisma.seccion.findMany({
                where,
                include: {
                    grado: true,
                    _count: {
                        select: {
                            alumnos: true,
                            horarios: true,
                        },
                    },
                },
                skip,
                take: limit,
                orderBy: { nombre: 'asc' },
            }),
            this.prisma.seccion.count({ where }),
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
        return this.prisma.seccion.findUnique({
            where: { id },
            include: {
                grado: true,
                alumnos: {
                    where: { activo: true },
                    include: {
                        usuario: true,
                    },
                },
            },
        });
    }
};
exports.SeccionesService = SeccionesService;
exports.SeccionesService = SeccionesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SeccionesService);
//# sourceMappingURL=secciones.service.js.map