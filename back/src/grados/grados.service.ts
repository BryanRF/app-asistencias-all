import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGradoDto } from './dto/create-grado.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class GradosService {
  constructor(private prisma: PrismaService) {}

  async create(createGradoDto: CreateGradoDto) {
    return this.prisma.grado.create({
      data: createGradoDto,
    });
  }

  async findAll(pagination: PaginationDto) {
    const { page = 1, limit = 10 } = pagination;
    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
      this.prisma.grado.findMany({
        where: { activo: true },
        include: {
          secciones: {
            where: { activo: true },
          },
          _count: {
            select: {
              cursos: true,
              secciones: true,
            },
          },
        },
        skip,
        take: limit,
        orderBy: { nombre: 'asc' },
      }),
      this.prisma.grado.count({ where: { activo: true } }),
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
    return this.prisma.grado.findUnique({
      where: { id },
      include: {
        secciones: {
          where: { activo: true },
        },
        cursos: {
          where: { activo: true },
        },
      },
    });
  }
}

