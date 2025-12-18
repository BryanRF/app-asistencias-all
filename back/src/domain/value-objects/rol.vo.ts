export enum Rol {
    ALUMNO = 'ALUMNO',
    PROFESOR = 'PROFESOR',
    ADMIN = 'ADMIN',
}

export class RolVO {
    static isValid(rol: string): boolean {
        return Object.values(Rol).includes(rol as Rol);
    }

    static fromString(rol: string): Rol {
        if (!this.isValid(rol)) {
            throw new Error(`Rol inválido: ${rol}`);
        }
        return rol as Rol;
    }
}
