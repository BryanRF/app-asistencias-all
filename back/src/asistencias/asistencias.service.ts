import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAsistenciaDto, CreateMultipleAsistenciaDto } from './dto/create-asistencia.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class AsistenciasService {
  constructor(private prisma: PrismaService) { }

  async create(createAsistenciaDto: CreateAsistenciaDto) {
    const fecha = new Date(createAsistenciaDto.fecha);

    // Verificar si ya existe una asistencia para esta fecha, horario y alumno
    const existe = await this.prisma.asistencia.findUnique({
      where: {
        fecha_horarioId_alumnoId: {
          fecha: fecha,
          horarioId: createAsistenciaDto.horarioId,
          alumnoId: createAsistenciaDto.alumnoId,
        },
      },
    });

    if (existe) {
      throw new BadRequestException('Ya existe una asistencia registrada para este alumno en esta fecha y horario');
    }

    return this.prisma.asistencia.create({
      data: {
        fecha: fecha,
        estado: createAsistenciaDto.estado,
        observacion: createAsistenciaDto.observacion,
        horarioId: createAsistenciaDto.horarioId,
        alumnoId: createAsistenciaDto.alumnoId,
      },
      include: {
        horario: {
          include: {
            curso: true,
            seccion: {
              include: {
                grado: true,
              },
            },
            profesor: {
              include: {
                usuario: true,
              },
            },
          },
        },
        alumno: {
          include: {
            usuario: true,
            seccion: true,
          },
        },
      },
    });
  }

  async createMultiple(createMultipleDto: CreateMultipleAsistenciaDto) {
    const fecha = new Date(createMultipleDto.fecha);

    // Verificar el horario
    const horario = await this.prisma.horario.findUnique({
      where: { id: createMultipleDto.horarioId },
    });

    if (!horario) {
      throw new BadRequestException('Horario no encontrado');
    }

    const resultados: any[] = [];
    const errores: { alumnoId: number; error: string }[] = [];

    for (const asistencia of createMultipleDto.asistencias) {
      try {
        // Verificar si ya existe
        const existe = await this.prisma.asistencia.findUnique({
          where: {
            fecha_horarioId_alumnoId: {
              fecha: fecha,
              horarioId: createMultipleDto.horarioId,
              alumnoId: asistencia.alumnoId,
            },
          },
        });

        if (existe) {
          errores.push({
            alumnoId: asistencia.alumnoId,
            error: 'Ya existe una asistencia registrada',
          });
          continue;
        }

        const creada = await this.prisma.asistencia.create({
          data: {
            fecha: fecha,
            estado: asistencia.estado,
            observacion: asistencia.observacion,
            horarioId: createMultipleDto.horarioId,
            alumnoId: asistencia.alumnoId,
          },
          include: {
            alumno: {
              include: {
                usuario: true,
              },
            },
          },
        });

        resultados.push(creada);
      } catch (error) {
        errores.push({
          alumnoId: asistencia.alumnoId,
          error: error.message,
        });
      }
    }

    return {
      creadas: resultados,
      errores,
      total: resultados.length,
    };
  }

  async findAll(pagination: PaginationDto, filters?: {
    fechaInicio?: string;
    fechaFin?: string;
    horarioId?: number;
    alumnoId?: number;
    seccionId?: number;
  }) {
    const { page = 1, limit = 10 } = pagination;
    const skip = (page - 1) * limit;

    const where: any = {};

    if (filters?.fechaInicio || filters?.fechaFin) {
      where.fecha = {};
      if (filters.fechaInicio) {
        where.fecha.gte = new Date(filters.fechaInicio);
      }
      if (filters.fechaFin) {
        where.fecha.lte = new Date(filters.fechaFin);
      }
    }

    if (filters?.horarioId) {
      where.horarioId = filters.horarioId;
    }

    if (filters?.alumnoId) {
      where.alumnoId = filters.alumnoId;
    }

    if (filters?.seccionId) {
      where.alumno = {
        seccionId: filters.seccionId,
      };
    }

    const [data, total] = await Promise.all([
      this.prisma.asistencia.findMany({
        where,
        include: {
          horario: {
            include: {
              curso: true,
              seccion: {
                include: {
                  grado: true,
                },
              },
              profesor: {
                include: {
                  usuario: true,
                },
              },
            },
          },
          alumno: {
            include: {
              usuario: true,
              seccion: {
                include: {
                  grado: true,
                },
              },
            },
          },
        },
        skip,
        take: limit,
        orderBy: { fecha: 'desc' },
      }),
      this.prisma.asistencia.count({ where }),
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
    return this.prisma.asistencia.findUnique({
      where: { id },
      include: {
        horario: {
          include: {
            curso: true,
            seccion: {
              include: {
                grado: true,
              },
            },
            profesor: {
              include: {
                usuario: true,
              },
            },
          },
        },
        alumno: {
          include: {
            usuario: true,
            seccion: {
              include: {
                grado: true,
              },
            },
          },
        },
      },
    });
  }

  async getByHorarioAndFecha(horarioId: number, fecha: string) {
    const fechaDate = new Date(fecha);

    return this.prisma.asistencia.findMany({
      where: {
        horarioId,
        fecha: fechaDate,
      },
      include: {
        alumno: {
          include: {
            usuario: true,
            seccion: true,
          },
        },
      },
      orderBy: {
        alumno: {
          usuario: {
            apellidos: 'asc',
          },
        },
      },
    });
  }
}

