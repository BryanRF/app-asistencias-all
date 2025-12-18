import { Rol } from '../value-objects/rol.vo';
export interface UsuarioProps {
    id?: number;
    dni: string;
    nombres: string;
    apellidos: string;
    email?: string | null;
    password: string;
    rol: Rol;
    activo: boolean;
    createdAt?: Date;
    updatedAt?: Date;
}
export declare class Usuario {
    private readonly props;
    private constructor();
    static create(props: UsuarioProps): Usuario;
    static fromPersistence(data: any): Usuario;
    get id(): number | undefined;
    get dni(): string;
    get nombres(): string;
    get apellidos(): string;
    get nombreCompleto(): string;
    get email(): string | null | undefined;
    get password(): string;
    get rol(): Rol;
    get activo(): boolean;
    isProfesor(): boolean;
    isAlumno(): boolean;
    isAdmin(): boolean;
    toPersistence(): UsuarioProps;
}
