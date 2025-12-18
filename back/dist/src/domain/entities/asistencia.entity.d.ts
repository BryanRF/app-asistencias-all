import { EstadoAsistencia } from '../value-objects/estado-asistencia.vo';
export interface AsistenciaProps {
    id?: number;
    fecha: Date;
    estado: EstadoAsistencia;
    observacion?: string | null;
    horarioId: number;
    alumnoId: number;
    createdAt?: Date;
    updatedAt?: Date;
}
export declare class Asistencia {
    private readonly props;
    private constructor();
    static create(props: AsistenciaProps): Asistencia;
    static fromPersistence(data: any): Asistencia;
    get id(): number | undefined;
    get fecha(): Date;
    get estado(): EstadoAsistencia;
    get observacion(): string | null | undefined;
    get horarioId(): number;
    get alumnoId(): number;
    cambiarEstado(nuevoEstado: EstadoAsistencia): void;
    agregarObservacion(observacion: string): void;
    toPersistence(): AsistenciaProps;
}
