import { IsString, IsNotEmpty, Length } from 'class-validator';

export class LoginDto {
  @IsString()
  @IsNotEmpty()
  @Length(8, 8, { message: 'El DNI debe tener 8 caracteres' })
  dni: string;

  @IsString()
  @IsNotEmpty()
  password: string;
}

export class LoginResponseDto {
  access_token: string;
  user: {
    id: number;
    dni: string;
    nombres: string;
    apellidos: string;
    email: string;
    rol: string;
  };
}

