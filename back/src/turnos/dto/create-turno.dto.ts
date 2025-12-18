import { IsString, IsNotEmpty } from 'class-validator';

export class CreateTurnoDto {
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @IsString()
  @IsNotEmpty()
  horaInicio: string;

  @IsString()
  @IsNotEmpty()
  horaFin: string;
}

