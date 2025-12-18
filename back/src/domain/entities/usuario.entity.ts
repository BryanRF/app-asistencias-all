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

export class Usuario {
    private readonly props: UsuarioProps;

    private constructor(props: UsuarioProps) {
        this.props = props;
    }

    static create(props: UsuarioProps): Usuario {
        if (!props.dni || props.dni.length !== 8) {
            throw new Error('El DNI debe tener 8 dígitos');
        }
        if (!props.nombres) {
            throw new Error('Los nombres son requeridos');
        }
        if (!props.apellidos) {
            throw new Error('Los apellidos son requeridos');
        }
        if (!props.password) {
            throw new Error('La contraseña es requerida');
        }

        return new Usuario(props);
    }

    static fromPersistence(data: any): Usuario {
        return new Usuario({
            id: data.id,
            dni: data.dni,
            nombres: data.nombres,
            apellidos: data.apellidos,
            email: data.email,
            password: data.password,
            rol: data.rol as Rol,
            activo: data.activo,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
        });
    }

    get id(): number | undefined {
        return this.props.id;
    }

    get dni(): string {
        return this.props.dni;
    }

    get nombres(): string {
        return this.props.nombres;
    }

    get apellidos(): string {
        return this.props.apellidos;
    }

    get nombreCompleto(): string {
        return `${this.props.nombres} ${this.props.apellidos}`;
    }

    get email(): string | null | undefined {
        return this.props.email;
    }

    get password(): string {
        return this.props.password;
    }

    get rol(): Rol {
        return this.props.rol;
    }

    get activo(): boolean {
        return this.props.activo;
    }

    isProfesor(): boolean {
        return this.props.rol === Rol.PROFESOR;
    }

    isAlumno(): boolean {
        return this.props.rol === Rol.ALUMNO;
    }

    isAdmin(): boolean {
        return this.props.rol === Rol.ADMIN;
    }

    toPersistence(): UsuarioProps {
        return { ...this.props };
    }
}
