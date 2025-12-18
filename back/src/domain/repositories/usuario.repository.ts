import { Usuario } from '../entities/usuario.entity';

export abstract class IUsuarioRepository {
    abstract findByDni(dni: string): Promise<Usuario | null>;
    abstract findById(id: number): Promise<Usuario | null>;
    abstract findByDniWithRelations(dni: string): Promise<any | null>;
}
