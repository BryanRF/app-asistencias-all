"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Asistencia = void 0;
class Asistencia {
    props;
    constructor(props) {
        this.props = props;
    }
    static create(props) {
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
    static fromPersistence(data) {
        return new Asistencia({
            id: data.id,
            fecha: data.fecha,
            estado: data.estado,
            observacion: data.observacion,
            horarioId: data.horarioId,
            alumnoId: data.alumnoId,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
        });
    }
    get id() {
        return this.props.id;
    }
    get fecha() {
        return this.props.fecha;
    }
    get estado() {
        return this.props.estado;
    }
    get observacion() {
        return this.props.observacion;
    }
    get horarioId() {
        return this.props.horarioId;
    }
    get alumnoId() {
        return this.props.alumnoId;
    }
    cambiarEstado(nuevoEstado) {
        this.props.estado = nuevoEstado;
    }
    agregarObservacion(observacion) {
        this.props.observacion = observacion;
    }
    toPersistence() {
        return { ...this.props };
    }
}
exports.Asistencia = Asistencia;
//# sourceMappingURL=asistencia.entity.js.map