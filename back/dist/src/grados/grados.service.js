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
exports.GradosService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let GradosService = class GradosService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(createGradoDto) {
        return this.prisma.grado.create({
            data: createGradoDto,
        });
    }
    async findAll(pagination) {
        const { page = 1, limit = 10 } = pagination;
        const skip = (page - 1) * limit;
        const [data, total] = await Promise.all([
            this.prisma.grado.findMany({
                where: { activo: true },
                include: {
                    secciones: {
                        where: { activo: true },
                    },
                    _count: {
                        select: {
                            cursos: true,
                            secciones: true,
                        },
                    },
                },
                skip,
                take: limit,
                orderBy: { nombre: 'asc' },
            }),
            this.prisma.grado.count({ where: { activo: true } }),
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
        return this.prisma.grado.findUnique({
            where: { id },
            include: {
                secciones: {
                    where: { activo: true },
                },
                cursos: {
                    where: { activo: true },
                },
            },
        });
    }
};
exports.GradosService = GradosService;
exports.GradosService = GradosService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], GradosService);
//# sourceMappingURL=grados.service.js.map