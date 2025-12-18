import {
    Controller,
    Get,
    Post,
    Body,
    Param,
    ParseIntPipe,
    Query,
    UseGuards,
    Request,
} from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { RolesGuard } from '../../common/guards/roles.guard';
import { CreateAsistenciaUseCase } from '../../application/use-cases/create-asistencia.use-case';
import { CreateMultipleAsistenciasUseCase } from '../../application/use-cases/create-multiple-asistencias.use-case';
import { GetAsistenciasUseCase } from '../../application/use-cases/get-asistencias.use-case';
import { GetAsistenciasByHorarioUseCase } from '../../application/use-cases/get-asistencias-by-horario.use-case';
import { CreateAsistenciaDto, CreateMultipleAsistenciaDto } from './dto/create-asistencia.dto';
import { PaginationDto } from '../../common/dto/pagination.dto';

@Controller('asistencias')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AsistenciasController {
    constructor(
        private readonly createAsistenciaUseCase: CreateAsistenciaUseCase,
        private readonly createMultipleAsistenciasUseCase: CreateMultipleAsistenciasUseCase,
        private readonly getAsistenciasUseCase: GetAsistenciasUseCase,
        private readonly getAsistenciasByHorarioUseCase: GetAsistenciasByHorarioUseCase,
    ) { }

    @Post()
    @Roles('PROFESOR', 'ADMIN')
    create(@Body() createAsistenciaDto: CreateAsistenciaDto) {
        return this.createAsistenciaUseCase.execute({
            fecha: createAsistenciaDto.fecha,
            estado: createAsistenciaDto.estado,
            observacion: createAsistenciaDto.observacion,
            horarioId: createAsistenciaDto.horarioId,
            alumnoId: createAsistenciaDto.alumnoId,
        });
    }

    @Post('multiple')
    @Roles('PROFESOR', 'ADMIN')
    createMultiple(@Body() createMultipleDto: CreateMultipleAsistenciaDto) {
        return this.createMultipleAsistenciasUseCase.execute({
            fecha: createMultipleDto.fecha,
            horarioId: createMultipleDto.horarioId,
            asistencias: createMultipleDto.asistencias,
        });
    }

    @Get()
    findAll(
        @Query() pagination: PaginationDto,
        @Query('fechaInicio') fechaInicio?: string,
        @Query('fechaFin') fechaFin?: string,
        @Query('horarioId') horarioId?: number,
        @Query('alumnoId') alumnoId?: number,
        @Query('seccionId') seccionId?: number,
        @Request() req?: any,
    ) {
        // Si es alumno, filtrar por su ID automáticamente
        let filteredAlumnoId = alumnoId ? parseInt(alumnoId.toString()) : undefined;
        if (req?.user?.rol === 'ALUMNO' && req?.user?.alumno?.id) {
            filteredAlumnoId = req.user.alumno.id;
        }

        return this.getAsistenciasUseCase.execute({
            page: pagination.page,
            limit: pagination.limit,
            fechaInicio,
            fechaFin,
            horarioId: horarioId ? parseInt(horarioId.toString()) : undefined,
            alumnoId: filteredAlumnoId,
            seccionId: seccionId ? parseInt(seccionId.toString()) : undefined,
        });
    }

    @Get('horario/:horarioId/fecha/:fecha')
    getByHorarioAndFecha(
        @Param('horarioId', ParseIntPipe) horarioId: number,
        @Param('fecha') fecha: string,
    ) {
        return this.getAsistenciasByHorarioUseCase.execute({ horarioId, fecha });
    }
}
