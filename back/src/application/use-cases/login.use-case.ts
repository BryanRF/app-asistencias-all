import { Injectable, Inject, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { IUsuarioRepository } from '../../domain/repositories/usuario.repository';

export interface LoginInput {
    dni: string;
    password: string;
}

export interface LoginOutput {
    access_token: string;
    user: {
        id: number;
        dni: string;
        nombres: string;
        apellidos: string;
        email: string;
        rol: string;
    };
}

@Injectable()
export class LoginUseCase {
    constructor(
        @Inject('IUsuarioRepository')
        private readonly usuarioRepository: IUsuarioRepository,
        private readonly jwtService: JwtService,
    ) { }

    async execute(input: LoginInput): Promise<LoginOutput> {
        // Buscar usuario por DNI con relaciones
        const usuario = await this.usuarioRepository.findByDniWithRelations(input.dni);

        if (!usuario || !usuario.activo) {
            throw new UnauthorizedException('Credenciales inválidas');
        }

        // Verificar contraseña
        const isPasswordValid = await bcrypt.compare(input.password, usuario.password);
        if (!isPasswordValid) {
            throw new UnauthorizedException('Credenciales inválidas');
        }

        // Generar token JWT
        const payload = {
            sub: usuario.id,
            dni: usuario.dni,
            rol: usuario.rol,
        };

        return {
            access_token: this.jwtService.sign(payload),
            user: {
                id: usuario.id,
                dni: usuario.dni,
                nombres: usuario.nombres,
                apellidos: usuario.apellidos,
                email: usuario.email ?? '',
                rol: usuario.rol,
            },
        };
    }
}
