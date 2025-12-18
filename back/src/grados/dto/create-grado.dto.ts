import { IsString, IsNotEmpty, IsEnum } from 'class-validator';
import { Nivel } from '@prisma/client';

export class CreateGradoDto {
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @IsEnum(Nivel)
  nivel: Nivel;
}

