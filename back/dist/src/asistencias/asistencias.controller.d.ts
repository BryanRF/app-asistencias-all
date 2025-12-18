import { AsistenciasService } from './asistencias.service';
import { CreateAsistenciaDto, CreateMultipleAsistenciaDto } from './dto/create-asistencia.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
export declare class AsistenciasController {
    private readonly asistenciasService;
    constructor(asistenciasService: AsistenciasService);
    create(createAsistenciaDto: CreateAsistenciaDto): Promise<{
        alumno: {
            seccion: {
                nombre: string;
                activo: boolean;
                createdAt: Date;
                updatedAt: Date;
                id: number;
                gradoId: number;
            };
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
        };
        horario: {
            seccion: {
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
            };
            curso: {
                nombre: string;
                activo: boolean;
                createdAt: Date;
                updatedAt: Date;
                id: number;
                gradoId: number;
                codigo: string;
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
        };
    } & {
        createdAt: Date;
        updatedAt: Date;
        id: number;
        fecha: Date;
        estado: import("@prisma/client").$Enums.EstadoAsistencia;
        observacion: string | null;
        horarioId: number;
        alumnoId: number;
    }>;
    createMultiple(createMultipleDto: CreateMultipleAsistenciaDto): Promise<{
        creadas: any[];
        errores: {
            alumnoId: number;
            error: string;
        }[];
        total: number;
    }>;
    findAll(pagination: PaginationDto, fechaInicio?: string, fechaFin?: string, horarioId?: number, alumnoId?: number, seccionId?: number, req?: any): Promise<import("../common/dto/pagination.dto").PaginatedResponse<any>>;
    getByHorarioAndFecha(horarioId: number, fecha: string): Promise<({
        alumno: {
            seccion: {
                nombre: string;
                activo: boolean;
                createdAt: Date;
                updatedAt: Date;
                id: number;
                gradoId: number;
            };
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
        };
    } & {
        createdAt: Date;
        updatedAt: Date;
        id: number;
        fecha: Date;
        estado: import("@prisma/client").$Enums.EstadoAsistencia;
        observacion: string | null;
        horarioId: number;
        alumnoId: number;
    })[]>;
    findOne(id: number): Promise<({
        alumno: {
            seccion: {
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
            };
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
        };
        horario: {
            seccion: {
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
            };
            curso: {
                nombre: string;
                activo: boolean;
                createdAt: Date;
                updatedAt: Date;
                id: number;
                gradoId: number;
                codigo: string;
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
        };
    } & {
        createdAt: Date;
        updatedAt: Date;
        id: number;
        fecha: Date;
        estado: import("@prisma/client").$Enums.EstadoAsistencia;
        observacion: string | null;
        horarioId: number;
        alumnoId: number;
    }) | null>;
}
