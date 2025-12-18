export declare class CreateAsistenciaDto {
    fecha: string;
    estado: string;
    observacion?: string;
    horarioId: number;
    alumnoId: number;
}
export declare class AsistenciaItemDto {
    alumnoId: number;
    estado: string;
    observacion?: string;
}
export declare class CreateMultipleAsistenciaDto {
    fecha: string;
    horarioId: number;
    asistencias: AsistenciaItemDto[];
}
