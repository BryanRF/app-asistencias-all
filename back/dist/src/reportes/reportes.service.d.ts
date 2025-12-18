import { PrismaService } from '../prisma/prisma.service';
export declare class ReportesService {
    private prisma;
    constructor(prisma: PrismaService);
    reportePorAlumno(alumnoId: number, fechaInicio?: string, fechaFin?: string): Promise<{
        resumen: {
            total: number;
            presentes: number;
            tardanzas: number;
            faltas: number;
            justificadas: number;
        };
        asistencias: ({
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
        })[];
    }>;
    reportePorSeccion(seccionId: number, fechaInicio?: string, fechaFin?: string): Promise<{
        seccionId: number;
        totalAlumnos: number;
        porAlumno: unknown[];
    }>;
    reportePorCurso(cursoId: number, fechaInicio?: string, fechaFin?: string): Promise<{
        cursoId: number;
        resumen: {
            total: number;
            presentes: number;
            tardanzas: number;
            faltas: number;
            justificadas: number;
        };
        asistencias: ({
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
                    nombre: string;
                    activo: boolean;
                    createdAt: Date;
                    updatedAt: Date;
                    id: number;
                    gradoId: number;
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
        })[];
    }>;
}
