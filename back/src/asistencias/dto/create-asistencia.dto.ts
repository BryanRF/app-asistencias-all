import { IsInt, IsEnum, IsOptional, IsString, IsDateString } from 'class-validator';
import { EstadoAsistencia } from '@prisma/client';

export class CreateAsistenciaDto {
  @IsDateString()
  fecha: string;

  @IsEnum(EstadoAsistencia)
  estado: EstadoAsistencia;

  @IsOptional()
  @IsString()
  observacion?: string;

  @IsInt()
  horarioId: number;

  @IsInt()
  alumnoId: number;
}

export class CreateMultipleAsistenciaDto {
  @IsDateString()
  fecha: string;

  @IsInt()
  horarioId: number;

  asistencias: {
    alumnoId: number;
    estado: EstadoAsistencia;
    observacion?: string;
  }[];
}

