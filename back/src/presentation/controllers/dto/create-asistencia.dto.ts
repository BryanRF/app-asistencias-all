import { IsInt, IsEnum, IsOptional, IsString, IsDateString, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { EstadoAsistencia } from '../../../domain/value-objects/estado-asistencia.vo';

export class CreateAsistenciaDto {
    @IsDateString()
    fecha: string;

    @IsEnum(EstadoAsistencia)
    estado: string;

    @IsOptional()
    @IsString()
    observacion?: string;

    @IsInt()
    horarioId: number;

    @IsInt()
    alumnoId: number;
}

export class AsistenciaItemDto {
    @IsInt()
    alumnoId: number;

    @IsEnum(EstadoAsistencia)
    estado: string;

    @IsOptional()
    @IsString()
    observacion?: string;
}

export class CreateMultipleAsistenciaDto {
    @IsDateString()
    fecha: string;

    @IsInt()
    horarioId: number;

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => AsistenciaItemDto)
    asistencias: AsistenciaItemDto[];
}
