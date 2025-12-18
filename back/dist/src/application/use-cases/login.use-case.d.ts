import { JwtService } from '@nestjs/jwt';
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
export declare class LoginUseCase {
    private readonly usuarioRepository;
    private readonly jwtService;
    constructor(usuarioRepository: IUsuarioRepository, jwtService: JwtService);
    execute(input: LoginInput): Promise<LoginOutput>;
}
