import { Controller, Get, Post, Body, Param, ParseIntPipe, Query, UseGuards, Request } from '@nestjs/common';
import { HorariosService } from './horarios.service';
import { CreateHorarioDto } from './dto/create-horario.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';

@Controller('horarios')
@UseGuards(JwtAuthGuard, RolesGuard)
export class HorariosController {
  constructor(private readonly horariosService: HorariosService) { }

  @Post()
  @Roles('ADMIN', 'PROFESOR')
  create(@Body() createHorarioDto: CreateHorarioDto) {
    return this.horariosService.create(createHorarioDto);
  }

  @Get()
  findAll(
    @Query() pagination: PaginationDto,
    @Query('profesorId') profesorId?: number,
    @Query('seccionId') seccionId?: number,
    @Request() req?: any,
  ) {
    // Si es profesor, filtrar por su ID automáticamente
    if (req?.user?.rol === 'PROFESOR' && req?.user?.profesor?.id) {
      profesorId = req.user.profesor.id;
    }
    return this.horariosService.findAll(pagination, profesorId, seccionId);
  }

  @Get('profesor/:profesorId')
  @Roles('ADMIN', 'PROFESOR')
  findByProfesor(@Param('profesorId', ParseIntPipe) profesorId: number) {
    return this.horariosService.findByProfesor(profesorId);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.horariosService.findOne(id);
  }

  @Get(':id/alumnos')
  @Roles('ADMIN', 'PROFESOR')
  getAlumnosByHorario(@Param('id', ParseIntPipe) id: number) {
    return this.horariosService.getAlumnosByHorario(id);
  }
}
