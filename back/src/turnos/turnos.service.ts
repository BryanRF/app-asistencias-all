import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateTurnoDto } from './dto/create-turno.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class TurnosService {
  constructor(private prisma: PrismaService) {}

  async create(createTurnoDto: CreateTurnoDto) {
    return this.prisma.turno.create({
      data: createTurnoDto,
    });
  }

  async findAll(pagination: PaginationDto) {
    const { page = 1, limit = 10 } = pagination;
    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
      this.prisma.turno.findMany({
        where: { activo: true },
        orderBy: { nombre: 'asc' },
        skip,
        take: limit,
      }),
      this.prisma.turno.count({ where: { activo: true } }),
    ]);

    return {
      data,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    } as PaginatedResponse<any>;
  }

  async findOne(id: number) {
    return this.prisma.turno.findUnique({
      where: { id },
    });
  }
}

