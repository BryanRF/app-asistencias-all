import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PrismaModule } from '../../prisma/prisma.module';

// Presentation
import { AuthController } from '../../presentation/controllers/auth.controller';

// Application - Use Cases
import { LoginUseCase } from '../../application/use-cases/login.use-case';
import { ValidateUserUseCase } from '../../application/use-cases/validate-user.use-case';

// Infrastructure - Repositories
import { PrismaUsuarioRepository } from '../repositories/prisma-usuario.repository';

// Strategies
import { JwtStrategy } from '../../common/strategies/jwt.strategy';

@Module({
    imports: [
        PrismaModule,
        PassportModule,
        JwtModule.registerAsync({
            imports: [ConfigModule],
            useFactory: async (configService: ConfigService) => ({
                secret: configService.get<string>('JWT_SECRET'),
                signOptions: { expiresIn: '24h' },
            }),
            inject: [ConfigService],
        }),
    ],
    controllers: [AuthController],
    providers: [
        // Use Cases
        LoginUseCase,
        ValidateUserUseCase,

        // Repository - Dependency Injection
        {
            provide: 'IUsuarioRepository',
            useClass: PrismaUsuarioRepository,
        },

        // Strategies
        JwtStrategy,
    ],
    exports: [
        'IUsuarioRepository',
        LoginUseCase,
        ValidateUserUseCase,
        JwtModule,
    ],
})
export class AuthModule { }
