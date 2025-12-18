import { Controller, Get, Post, Body, Param, ParseIntPipe, Query, UseGuards } from '@nestjs/common';
import { GradosService } from './grados.service';
import { CreateGradoDto } from './dto/create-grado.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';

@Controller('grados')
@UseGuards(JwtAuthGuard, RolesGuard)
export class GradosController {
  constructor(private readonly gradosService: GradosService) {}

  @Post()
  @Roles('ADMIN', 'PROFESOR')
  create(@Body() createGradoDto: CreateGradoDto) {
    return this.gradosService.create(createGradoDto);
  }

  @Get()
  findAll(@Query() pagination: PaginationDto) {
    return this.gradosService.findAll(pagination);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.gradosService.findOne(id);
  }
}

