import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCursoDto } from './dto/create-curso.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class CursosService {
  constructor(private prisma: PrismaService) {}

  async create(createCursoDto: CreateCursoDto) {
    return this.prisma.curso.create({
      data: createCursoDto,
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
      this.prisma.curso.findMany({
        where,
        include: {
          grado: true,
        },
        skip,
        take: limit,
        orderBy: { nombre: 'asc' },
      }),
      this.prisma.curso.count({ where }),
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
    return this.prisma.curso.findUnique({
      where: { id },
      include: {
        grado: true,
        horarios: {
          where: { activo: true },
          include: {
            seccion: true,
            turno: true,
            profesor: {
              include: {
                usuario: true,
              },
            },
          },
        },
      },
    });
  }
}

