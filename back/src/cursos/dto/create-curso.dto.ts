import { IsString, IsNotEmpty, IsInt } from 'class-validator';

export class CreateCursoDto {
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @IsString()
  @IsNotEmpty()
  codigo: string;

  @IsInt()
  gradoId: number;
}

