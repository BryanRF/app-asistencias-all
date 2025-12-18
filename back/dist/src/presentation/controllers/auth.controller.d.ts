import { LoginUseCase } from '../../application/use-cases/login.use-case';
import { LoginDto } from './dto/login.dto';
export declare class AuthController {
    private readonly loginUseCase;
    constructor(loginUseCase: LoginUseCase);
    login(loginDto: LoginDto): Promise<import("../../application/use-cases/login.use-case").LoginOutput>;
}
