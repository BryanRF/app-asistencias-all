import { HorariosService } from './horarios.service';
import { CreateHorarioDto } from './dto/create-horario.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
export declare class HorariosController {
    private readonly horariosService;
    constructor(horariosService: HorariosService);
    create(createHorarioDto: CreateHorarioDto): Promise<{
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
    }>;
    findAll(pagination: PaginationDto, profesorId?: number, seccionId?: number, req?: any): Promise<import("../common/dto/pagination.dto").PaginatedResponse<any>>;
    findByProfesor(profesorId: number): Promise<{
        data: ({
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
    }>;
    findOne(id: number): Promise<({
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
    }) | null>;
    getAlumnosByHorario(id: number): Promise<{
        data: ({
            usuario: {
                id: number;
                dni: string;
                nombres: string;
                apellidos: string;
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
    }>;
}
