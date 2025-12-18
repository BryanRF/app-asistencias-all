export enum EstadoAsistencia {
    PRESENTE = 'PRESENTE',
    TARDANZA = 'TARDANZA',
    FALTA = 'FALTA',
    JUSTIFICADA = 'JUSTIFICADA',
}

export class EstadoAsistenciaVO {
    private readonly value: EstadoAsistencia;

    private constructor(value: EstadoAsistencia) {
        this.value = value;
    }

    static create(value: string): EstadoAsistencia {
        const estado = value.toUpperCase() as EstadoAsistencia;

        if (!Object.values(EstadoAsistencia).includes(estado)) {
            throw new Error(`Estado de asistencia inválido: ${value}`);
        }

        return estado;
    }

    static isPresente(estado: EstadoAsistencia): boolean {
        return estado === EstadoAsistencia.PRESENTE;
    }

    static isFalta(estado: EstadoAsistencia): boolean {
        return estado === EstadoAsistencia.FALTA;
    }

    static isTardanza(estado: EstadoAsistencia): boolean {
        return estado === EstadoAsistencia.TARDANZA;
    }

    static isJustificada(estado: EstadoAsistencia): boolean {
        return estado === EstadoAsistencia.JUSTIFICADA;
    }
}
