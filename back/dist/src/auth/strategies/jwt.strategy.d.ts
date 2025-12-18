import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../prisma/prisma.service';
declare const JwtStrategy_base: new (...args: any) => any;
export declare class JwtStrategy extends JwtStrategy_base {
    private configService;
    private prisma;
    constructor(configService: ConfigService, prisma: PrismaService);
    validate(payload: any): Promise<{
        id: number;
        dni: string;
        nombres: string;
        apellidos: string;
        email: string | null;
        rol: import("@prisma/client").$Enums.Rol;
        alumno: {
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            codigo: string;
            usuarioId: number;
            seccionId: number;
        } | null;
        profesor: {
            activo: boolean;
            createdAt: Date;
            updatedAt: Date;
            id: number;
            codigo: string;
            usuarioId: number;
        } | null;
    }>;
}
export {};
