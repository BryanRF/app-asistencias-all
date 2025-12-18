import { GradosService } from './grados.service';
import { CreateGradoDto } from './dto/create-grado.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
export declare class GradosController {
    private readonly gradosService;
    constructor(gradosService: GradosService);
    create(createGradoDto: CreateGradoDto): Promise<{
        nombre: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        nivel: import("@prisma/client").$Enums.Nivel;
    }>;
    findAll(pagination: PaginationDto): Promise<import("../common/dto/pagination.dto").PaginatedResponse<any>>;
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
