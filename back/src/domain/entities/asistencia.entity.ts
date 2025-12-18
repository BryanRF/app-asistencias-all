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

export class Asistencia {
    private readonly props: AsistenciaProps;

    private constructor(props: AsistenciaProps) {
        this.props = props;
    }

    static create(props: AsistenciaProps): Asistencia {
        // Validaciones de dominio
        if (!props.fecha) {
            throw new Error('La fecha es requerida');
        }
        if (!props.estado) {
            throw new Error('El estado es requerido');
        }
        if (!props.horarioId) {
            throw new Error('El horarioId es requerido');
        }
        if (!props.alumnoId) {
            throw new Error('El alumnoId es requerido');
        }

        return new Asistencia(props);
    }

    static fromPersistence(data: any): Asistencia {
        return new Asistencia({
            id: data.id,
            fecha: data.fecha,
            estado: data.estado as EstadoAsistencia,
            observacion: data.observacion,
            horarioId: data.horarioId,
            alumnoId: data.alumnoId,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
        });
    }

    get id(): number | undefined {
        return this.props.id;
    }

    get fecha(): Date {
        return this.props.fecha;
    }

    get estado(): EstadoAsistencia {
        return this.props.estado;
    }

    get observacion(): string | null | undefined {
        return this.props.observacion;
    }

    get horarioId(): number {
        return this.props.horarioId;
    }

    get alumnoId(): number {
        return this.props.alumnoId;
    }

    cambiarEstado(nuevoEstado: EstadoAsistencia): void {
        this.props.estado = nuevoEstado;
    }

    agregarObservacion(observacion: string): void {
        this.props.observacion = observacion;
    }

    toPersistence(): AsistenciaProps {
        return { ...this.props };
    }
}
