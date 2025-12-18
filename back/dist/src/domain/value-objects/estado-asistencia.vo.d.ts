export declare enum EstadoAsistencia {
    PRESENTE = "PRESENTE",
    TARDANZA = "TARDANZA",
    FALTA = "FALTA",
    JUSTIFICADA = "JUSTIFICADA"
}
export declare class EstadoAsistenciaVO {
    private readonly value;
    private constructor();
    static create(value: string): EstadoAsistencia;
    static isPresente(estado: EstadoAsistencia): boolean;
    static isFalta(estado: EstadoAsistencia): boolean;
    static isTardanza(estado: EstadoAsistencia): boolean;
    static isJustificada(estado: EstadoAsistencia): boolean;
}
