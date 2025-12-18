import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { LoginUseCase } from '../../application/use-cases/login.use-case';
import { Public } from '../../common/decorators/public.decorator';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
    constructor(private readonly loginUseCase: LoginUseCase) { }

    @Public()
    @Post('login')
    @HttpCode(HttpStatus.OK)
    async login(@Body() loginDto: LoginDto) {
        return this.loginUseCase.execute({
            dni: loginDto.dni,
            password: loginDto.password,
        });
    }
}
