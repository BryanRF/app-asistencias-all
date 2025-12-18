import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
    constructor(
        private configService: ConfigService,
        private prisma: PrismaService,
    ) {
        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,
            secretOrKey: configService.get<string>('JWT_SECRET') || 'secret-key-change-in-production',
        });
    }

    async validate(payload: any) {
        const user = await this.prisma.usuario.findUnique({
            where: { id: payload.sub },
            include: {
                alumno: true,
                profesor: true,
            },
        });

        if (!user || !user.activo) {
            throw new UnauthorizedException('Usuario no encontrado o inactivo');
        }

        return {
            id: user.id,
            dni: user.dni,
            nombres: user.nombres,
            apellidos: user.apellidos,
            email: user.email,
            rol: user.rol,
            alumno: user.alumno,
            profesor: user.profesor,
        };
    }
}
