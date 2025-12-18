import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { IUsuarioRepository } from '../../domain/repositories/usuario.repository';
import { Usuario } from '../../domain/entities/usuario.entity';

@Injectable()
export class PrismaUsuarioRepository implements IUsuarioRepository {
    constructor(private readonly prisma: PrismaService) { }

    async findByDni(dni: string): Promise<Usuario | null> {
        const found = await this.prisma.usuario.findUnique({
            where: { dni },
        });

        if (!found) return null;

        return Usuario.fromPersistence(found);
    }

    async findById(id: number): Promise<Usuario | null> {
        const found = await this.prisma.usuario.findUnique({
            where: { id },
        });

        if (!found) return null;

        return Usuario.fromPersistence(found);
    }

    async findByDniWithRelations(dni: string): Promise<any | null> {
        return this.prisma.usuario.findUnique({
            where: { dni },
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
    }
}
