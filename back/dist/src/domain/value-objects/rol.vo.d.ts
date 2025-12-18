export declare enum Rol {
    ALUMNO = "ALUMNO",
    PROFESOR = "PROFESOR",
    ADMIN = "ADMIN"
}
export declare class RolVO {
    static isValid(rol: string): boolean;
    static fromString(rol: string): Rol;
}
