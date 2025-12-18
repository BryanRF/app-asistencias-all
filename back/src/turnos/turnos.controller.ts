import { Controller, Get, Post, Body, Param, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import { TurnosService } from './turnos.service';
import { CreateTurnoDto } from './dto/create-turno.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';

@Controller('turnos')
@UseGuards(JwtAuthGuard, RolesGuard)
export class TurnosController {
  constructor(private readonly turnosService: TurnosService) {}

  @Post()
  @Roles('ADMIN', 'PROFESOR')
  create(@Body() createTurnoDto: CreateTurnoDto) {
    return this.turnosService.create(createTurnoDto);
  }

  @Get()
  findAll(@Query() pagination: PaginationDto) {
    return this.turnosService.findAll(pagination);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.turnosService.findOne(id);
  }
}

