import { PrismaService } from '../prisma/prisma.service';
import { CreateSeccionDto } from './dto/create-seccion.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';
export declare class SeccionesService {
    private prisma;
    constructor(prisma: PrismaService);
    create(createSeccionDto: CreateSeccionDto): Promise<{
        grado: {
            nombre: string;
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            nivel: import("@prisma/client").$Enums.Nivel;
        };
    } & {
        nombre: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        gradoId: number;
    }>;
    findAll(pagination: PaginationDto, gradoId?: number): Promise<PaginatedResponse<any>>;
    findOne(id: number): Promise<({
        grado: {
            nombre: string;
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            nivel: import("@prisma/client").$Enums.Nivel;
        };
        alumnos: ({
            usuario: {
                activo: boolean;
                createdAt: Date;
                updatedAt: Date;
                id: number;
                dni: string;
                nombres: string;
                apellidos: string;
                email: string | null;
                password: string;
                rol: import("@prisma/client").$Enums.Rol;
            };
        } & {
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            codigo: string;
            usuarioId: number;
            seccionId: number;
        })[];
    } & {
        nombre: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        gradoId: number;
    }) | null>;
}
