import { IsInt, IsString, IsNotEmpty, Min, Max } from 'class-validator';

export class CreateHorarioDto {
  @IsInt()
  @Min(1)
  @Max(7)
  diaSemana: number;

  @IsString()
  @IsNotEmpty()
  horaInicio: string;

  @IsString()
  @IsNotEmpty()
  horaFin: string;

  @IsInt()
  cursoId: number;

  @IsInt()
  seccionId: number;

  @IsInt()
  turnoId: number;

  @IsInt()
  profesorId: number;
}

