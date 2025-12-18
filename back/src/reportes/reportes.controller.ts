import { Controller, Get, Param, ParseIntPipe, Query, UseGuards, Request } from '@nestjs/common';
import { ReportesService } from './reportes.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';

@Controller('reportes')
@UseGuards(JwtAuthGuard, RolesGuard)
export class ReportesController {
  constructor(private readonly reportesService: ReportesService) {}

  @Get('alumno/:alumnoId')
  @Roles('ADMIN', 'PROFESOR', 'ALUMNO')
  reportePorAlumno(
    @Param('alumnoId', ParseIntPipe) alumnoId: number,
    @Query('fechaInicio') fechaInicio?: string,
    @Query('fechaFin') fechaFin?: string,
    @Request() req?: any,
  ) {
    // Si es alumno, solo puede ver su propio reporte
    if (req?.user?.rol === 'ALUMNO' && req?.user?.alumno?.id !== alumnoId) {
      throw new Error('No autorizado');
    }
    return this.reportesService.reportePorAlumno(alumnoId, fechaInicio, fechaFin);
  }

  @Get('seccion/:seccionId')
  @Roles('ADMIN', 'PROFESOR')
  reportePorSeccion(
    @Param('seccionId', ParseIntPipe) seccionId: number,
    @Query('fechaInicio') fechaInicio?: string,
    @Query('fechaFin') fechaFin?: string,
  ) {
    return this.reportesService.reportePorSeccion(seccionId, fechaInicio, fechaFin);
  }

  @Get('curso/:cursoId')
  @Roles('ADMIN', 'PROFESOR')
  reportePorCurso(
    @Param('cursoId', ParseIntPipe) cursoId: number,
    @Query('fechaInicio') fechaInicio?: string,
    @Query('fechaFin') fechaFin?: string,
  ) {
    return this.reportesService.reportePorCurso(cursoId, fechaInicio, fechaFin);
  }
}

