import { IsString, IsNotEmpty, IsInt } from 'class-validator';

export class CreateSeccionDto {
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @IsInt()
  gradoId: number;
}

