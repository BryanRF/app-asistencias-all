import { PrismaService } from '../prisma/prisma.service';
import { CreateHorarioDto } from './dto/create-horario.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';
export declare class HorariosService {
    private prisma;
    constructor(prisma: PrismaService);
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
    findAll(pagination: PaginationDto, profesorId?: number, seccionId?: number): Promise<PaginatedResponse<any>>;
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
    getAlumnosByHorario(horarioId: number): Promise<{
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
