import { CursosService } from './cursos.service';
import { CreateCursoDto } from './dto/create-curso.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
export declare class CursosController {
    private readonly cursosService;
    constructor(cursosService: CursosService);
    create(createCursoDto: CreateCursoDto): Promise<{
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
        codigo: string;
    }>;
    findAll(pagination: PaginationDto, gradoId?: number): Promise<import("../common/dto/pagination.dto").PaginatedResponse<any>>;
    findOne(id: number): Promise<({
        horarios: ({
            turno: {
                nombre: string;
                horaInicio: string;
                horaFin: string;
                activo: boolean;
                createdAt: Date;
                updatedAt: Date;
                id: number;
            };
            seccion: {
                nombre: string;
                activo: boolean;
                createdAt: Date;
                updatedAt: Date;
                id: number;
                gradoId: number;
            };
            profesor: {
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
            };
        } & {
            horaInicio: string;
            horaFin: string;
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            seccionId: number;
            diaSemana: number;
            cursoId: number;
            turnoId: number;
            profesorId: number;
        })[];
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
        codigo: string;
    }) | null>;
}
