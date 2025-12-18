import { Controller, Get, Post, Body, Param, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import { CursosService } from './cursos.service';
import { CreateCursoDto } from './dto/create-curso.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';

@Controller('cursos')
@UseGuards(JwtAuthGuard, RolesGuard)
export class CursosController {
  constructor(private readonly cursosService: CursosService) {}

  @Post()
  @Roles('ADMIN', 'PROFESOR')
  create(@Body() createCursoDto: CreateCursoDto) {
    return this.cursosService.create(createCursoDto);
  }

  @Get()
  findAll(@Query() pagination: PaginationDto, @Query('gradoId') gradoId?: number) {
    return this.cursosService.findAll(pagination, gradoId ? parseInt(gradoId.toString()) : undefined);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.cursosService.findOne(id);
  }
}

