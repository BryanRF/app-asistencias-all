import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { LoginDto, LoginResponseDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) { }

  async login(loginDto: LoginDto): Promise<LoginResponseDto> {
    const usuario = await this.prisma.usuario.findUnique({
      where: { dni: loginDto.dni },
      include: {
        alumno: {
          include: {
            seccion: {
              include: {
                grado: true,
              },
            },
          },
        },
        profesor: true,
      },
    });

    if (!usuario || !usuario.activo) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    const isPasswordValid = await bcrypt.compare(loginDto.password, usuario.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

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

  async validateUser(userId: number) {
    const usuario = await this.prisma.usuario.findUnique({
      where: { id: userId },
      include: {
        alumno: true,
        profesor: true,
      },
    });

    if (!usuario || !usuario.activo) {
      return null;
    }

    return usuario;
  }
}

