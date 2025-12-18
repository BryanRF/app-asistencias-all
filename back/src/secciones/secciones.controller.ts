import { Controller, Get, Post, Body, Param, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import { SeccionesService } from './secciones.service';
import { CreateSeccionDto } from './dto/create-seccion.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';

@Controller('secciones')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SeccionesController {
  constructor(private readonly seccionesService: SeccionesService) {}

  @Post()
  @Roles('ADMIN', 'PROFESOR')
  create(@Body() createSeccionDto: CreateSeccionDto) {
    return this.seccionesService.create(createSeccionDto);
  }

  @Get()
  findAll(@Query() pagination: PaginationDto, @Query('gradoId') gradoId?: number) {
    return this.seccionesService.findAll(pagination, gradoId ? parseInt(gradoId.toString()) : undefined);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.seccionesService.findOne(id);
  }
}

