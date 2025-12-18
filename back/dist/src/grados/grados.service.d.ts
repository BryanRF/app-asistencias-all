import { PrismaService } from '../prisma/prisma.service';
import { CreateGradoDto } from './dto/create-grado.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';
export declare class GradosService {
    private prisma;
    constructor(prisma: PrismaService);
    create(createGradoDto: CreateGradoDto): Promise<{
        nombre: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        nivel: import("@prisma/client").$Enums.Nivel;
    }>;
    findAll(pagination: PaginationDto): Promise<PaginatedResponse<any>>;
    findOne(id: number): Promise<({
        secciones: {
            nombre: string;
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            gradoId: number;
        }[];
        cursos: {
            nombre: string;
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            gradoId: number;
            codigo: string;
        }[];
    } & {
        nombre: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        nivel: import("@prisma/client").$Enums.Nivel;
    }) | null>;
}
