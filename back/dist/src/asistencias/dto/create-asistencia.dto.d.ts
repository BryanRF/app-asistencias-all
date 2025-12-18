import { EstadoAsistencia } from '@prisma/client';
export declare class CreateAsistenciaDto {
    fecha: string;
    estado: EstadoAsistencia;
    observacion?: string;
    horarioId: number;
    alumnoId: number;
}
export declare class CreateMultipleAsistenciaDto {
    fecha: string;
    horarioId: number;
    asistencias: {
        alumnoId: number;
        estado: EstadoAsistencia;
        observacion?: string;
    }[];
}
