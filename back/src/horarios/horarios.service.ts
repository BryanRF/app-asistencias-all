import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateHorarioDto } from './dto/create-horario.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class HorariosService {
  constructor(private prisma: PrismaService) { }

  async create(createHorarioDto: CreateHorarioDto) {
    return this.prisma.horario.create({
      data: createHorarioDto,
      include: {
        curso: true,
        seccion: {
          include: {
            grado: true,
          },
        },
        turno: true,
        profesor: {
          include: {
            usuario: true,
          },
        },
      },
    });
  }

  async findAll(pagination: PaginationDto, profesorId?: number, seccionId?: number) {
    const { page = 1, limit = 10 } = pagination;
    const skip = (page - 1) * limit;

    const where: any = { activo: true };
    if (profesorId) {
      where.profesorId = profesorId;
    }
    if (seccionId) {
      where.seccionId = seccionId;
    }

    const [data, total] = await Promise.all([
      this.prisma.horario.findMany({
        where,
        include: {
          curso: true,
          seccion: {
            include: {
              grado: true,
            },
          },
          turno: true,
          profesor: {
            include: {
              usuario: true,
            },
          },
        },
        skip,
        take: limit,
        orderBy: [
          { diaSemana: 'asc' },
          { horaInicio: 'asc' },
        ],
      }),
      this.prisma.horario.count({ where }),
    ]);

    return {
      data,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    } as PaginatedResponse<any>;
  }

  async findByProfesor(profesorId: number) {
    const data = await this.prisma.horario.findMany({
      where: {
        profesorId,
        activo: true,
      },
      include: {
        curso: true,
        seccion: {
          include: {
            grado: true,
          },
        },
        turno: true,
      },
      orderBy: [
        { diaSemana: 'asc' },
        { horaInicio: 'asc' },
      ],
    });

    return { data };
  }

  async findOne(id: number) {
    return this.prisma.horario.findUnique({
      where: { id },
      include: {
        curso: true,
        seccion: {
          include: {
            grado: true,
            alumnos: {
              where: { activo: true },
              include: {
                usuario: true,
              },
            },
          },
        },
        turno: true,
        profesor: {
          include: {
            usuario: true,
          },
        },
      },
    });
  }

  async getAlumnosByHorario(horarioId: number) {
    const horario = await this.prisma.horario.findUnique({
      where: { id: horarioId },
      include: {
        seccion: {
          include: {
            alumnos: {
              where: { activo: true },
              include: {
                usuario: {
                  select: {
                    id: true,
                    dni: true,
                    nombres: true,
                    apellidos: true,
                  },
                },
              },
              orderBy: {
                usuario: {
                  apellidos: 'asc',
                },
              },
            },
          },
        },
      },
    });

    return {
      data: horario?.seccion?.alumnos || [],
    };
  }
}
