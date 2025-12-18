"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EstadoAsistenciaVO = exports.EstadoAsistencia = void 0;
var EstadoAsistencia;
(function (EstadoAsistencia) {
    EstadoAsistencia["PRESENTE"] = "PRESENTE";
    EstadoAsistencia["TARDANZA"] = "TARDANZA";
    EstadoAsistencia["FALTA"] = "FALTA";
    EstadoAsistencia["JUSTIFICADA"] = "JUSTIFICADA";
})(EstadoAsistencia || (exports.EstadoAsistencia = EstadoAsistencia = {}));
class EstadoAsistenciaVO {
    value;
    constructor(value) {
        this.value = value;
    }
    static create(value) {
        const estado = value.toUpperCase();
        if (!Object.values(EstadoAsistencia).includes(estado)) {
            throw new Error(`Estado de asistencia inválido: ${value}`);
        }
        return estado;
    }
    static isPresente(estado) {
        return estado === EstadoAsistencia.PRESENTE;
    }
    static isFalta(estado) {
        return estado === EstadoAsistencia.FALTA;
    }
    static isTardanza(estado) {
        return estado === EstadoAsistencia.TARDANZA;
    }
    static isJustificada(estado) {
        return estado === EstadoAsistencia.JUSTIFICADA;
    }
}
exports.EstadoAsistenciaVO = EstadoAsistenciaVO;
//# sourceMappingURL=estado-asistencia.vo.js.map