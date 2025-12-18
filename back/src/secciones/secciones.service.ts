import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSeccionDto } from './dto/create-seccion.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class SeccionesService {
  constructor(private prisma: PrismaService) {}

  async create(createSeccionDto: CreateSeccionDto) {
    return this.prisma.seccion.create({
      data: createSeccionDto,
      include: {
        grado: true,
      },
    });
  }

  async findAll(pagination: PaginationDto, gradoId?: number) {
    const { page = 1, limit = 10 } = pagination;
    const skip = (page - 1) * limit;

    const where: any = { activo: true };
    if (gradoId) {
      where.gradoId = gradoId;
    }

    const [data, total] = await Promise.all([
      this.prisma.seccion.findMany({
        where,
        include: {
          grado: true,
          _count: {
            select: {
              alumnos: true,
              horarios: true,
            },
          },
        },
        skip,
        take: limit,
        orderBy: { nombre: 'asc' },
      }),
      this.prisma.seccion.count({ where }),
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
    return this.prisma.seccion.findUnique({
      where: { id },
      include: {
        grado: true,
        alumnos: {
          where: { activo: true },
          include: {
            usuario: true,
          },
        },
      },
    });
  }
}

