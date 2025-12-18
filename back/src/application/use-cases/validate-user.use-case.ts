import { Injectable, Inject } from '@nestjs/common';
import { IUsuarioRepository } from '../../domain/repositories/usuario.repository';
import { Usuario } from '../../domain/entities/usuario.entity';

@Injectable()
export class ValidateUserUseCase {
    constructor(
        @Inject('IUsuarioRepository')
        private readonly usuarioRepository: IUsuarioRepository,
    ) { }

    async execute(userId: number): Promise<Usuario | null> {
        const usuario = await this.usuarioRepository.findById(userId);

        if (!usuario || !usuario.activo) {
            return null;
        }

        return usuario;
    }
}
