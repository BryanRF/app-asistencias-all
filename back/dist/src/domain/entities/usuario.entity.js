"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Usuario = void 0;
const rol_vo_1 = require("../value-objects/rol.vo");
class Usuario {
    props;
    constructor(props) {
        this.props = props;
    }
    static create(props) {
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
    static fromPersistence(data) {
        return new Usuario({
            id: data.id,
            dni: data.dni,
            nombres: data.nombres,
            apellidos: data.apellidos,
            email: data.email,
            password: data.password,
            rol: data.rol,
            activo: data.activo,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
        });
    }
    get id() {
        return this.props.id;
    }
    get dni() {
        return this.props.dni;
    }
    get nombres() {
        return this.props.nombres;
    }
    get apellidos() {
        return this.props.apellidos;
    }
    get nombreCompleto() {
        return `${this.props.nombres} ${this.props.apellidos}`;
    }
    get email() {
        return this.props.email;
    }
    get password() {
        return this.props.password;
    }
    get rol() {
        return this.props.rol;
    }
    get activo() {
        return this.props.activo;
    }
    isProfesor() {
        return this.props.rol === rol_vo_1.Rol.PROFESOR;
    }
    isAlumno() {
        return this.props.rol === rol_vo_1.Rol.ALUMNO;
    }
    isAdmin() {
        return this.props.rol === rol_vo_1.Rol.ADMIN;
    }
    toPersistence() {
        return { ...this.props };
    }
}
exports.Usuario = Usuario;
//# sourceMappingURL=usuario.entity.js.map