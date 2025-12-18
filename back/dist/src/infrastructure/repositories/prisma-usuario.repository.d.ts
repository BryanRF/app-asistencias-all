import { PrismaService } from '../../prisma/prisma.service';
import { IUsuarioRepository } from '../../domain/repositories/usuario.repository';
import { Usuario } from '../../domain/entities/usuario.entity';
export declare class PrismaUsuarioRepository implements IUsuarioRepository {
    private readonly prisma;
    constructor(prisma: PrismaService);
    findByDni(dni: string): Promise<Usuario | null>;
    findById(id: number): Promise<Usuario | null>;
    findByDniWithRelations(dni: string): Promise<any | null>;
}
