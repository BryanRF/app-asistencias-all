import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto, LoginResponseDto } from './dto/login.dto';
export declare class AuthService {
    private prisma;
    private jwtService;
    constructor(prisma: PrismaService, jwtService: JwtService);
    login(loginDto: LoginDto): Promise<LoginResponseDto>;
    validateUser(userId: number): Promise<({
        profesor: {
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            codigo: string;
            usuarioId: number;
        } | null;
        alumno: {
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            codigo: string;
            usuarioId: number;
            seccionId: number;
        } | null;
    } & {
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
        dni: string;
        nombres: string;
        apellidos: string;
        email: string | null;
        password: string;
        rol: import("@prisma/client").$Enums.Rol;
    }) | null>;
}
