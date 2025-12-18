import { IUsuarioRepository } from '../../domain/repositories/usuario.repository';
import { Usuario } from '../../domain/entities/usuario.entity';
export declare class ValidateUserUseCase {
    private readonly usuarioRepository;
    constructor(usuarioRepository: IUsuarioRepository);
    execute(userId: number): Promise<Usuario | null>;
}
