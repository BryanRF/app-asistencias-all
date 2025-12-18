import { IsString, Length } from 'class-validator';

export class LoginDto {
    @IsString()
    @Length(8, 8, { message: 'El DNI debe tener 8 caracteres' })
    dni: string;

    @IsString()
    password: string;
}
