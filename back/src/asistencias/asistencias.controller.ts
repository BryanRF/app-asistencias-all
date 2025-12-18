import { Controller, Get, Post, Body, Param, ParseIntPipe, Query, UseGuards, Request } from '@nestjs/common';
import { AsistenciasService } from './asistencias.service';
import { CreateAsistenciaDto, CreateMultipleAsistenciaDto } from './dto/create-asistencia.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';

@Controller('asistencias')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AsistenciasController {
  constructor(private readonly asistenciasService: AsistenciasService) {}

  @Post()
  @Roles('PROFESOR', 'ADMIN')
  create(@Body() createAsistenciaDto: CreateAsistenciaDto) {
    return this.asistenciasService.create(createAsistenciaDto);
  }

  @Post('multiple')
  @Roles('PROFESOR', 'ADMIN')
  createMultiple(@Body() createMultipleDto: CreateMultipleAsistenciaDto) {
    return this.asistenciasService.createMultiple(createMultipleDto);
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
    const filters: any = {};
    if (fechaInicio) filters.fechaInicio = fechaInicio;
    if (fechaFin) filters.fechaFin = fechaFin;
    if (horarioId) filters.horarioId = parseInt(horarioId.toString());
    if (alumnoId) filters.alumnoId = parseInt(alumnoId.toString());
    if (seccionId) filters.seccionId = parseInt(seccionId.toString());

    // Si es alumno, filtrar por su ID automáticamente
    if (req?.user?.rol === 'ALUMNO' && req?.user?.alumno?.id) {
      filters.alumnoId = req.user.alumno.id;
    }

    return this.asistenciasService.findAll(pagination, filters);
  }

  @Get('horario/:horarioId/fecha/:fecha')
  getByHorarioAndFecha(
    @Param('horarioId', ParseIntPipe) horarioId: number,
    @Param('fecha') fecha: string,
  ) {
    return this.asistenciasService.getByHorarioAndFecha(horarioId, fecha);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.asistenciasService.findOne(id);
  }
}

