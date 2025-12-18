import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ReportesService {
  constructor(private prisma: PrismaService) {}

  async reportePorAlumno(alumnoId: number, fechaInicio?: string, fechaFin?: string) {
    const where: any = { alumnoId };

    if (fechaInicio || fechaFin) {
      where.fecha = {};
      if (fechaInicio) {
        where.fecha.gte = new Date(fechaInicio);
      }
      if (fechaFin) {
        where.fecha.lte = new Date(fechaFin);
      }
    }

    const asistencias = await this.prisma.asistencia.findMany({
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
          },
        },
      },
      orderBy: { fecha: 'desc' },
    });

    const resumen = {
      total: asistencias.length,
      presentes: asistencias.filter(a => a.estado === 'PRESENTE').length,
      tardanzas: asistencias.filter(a => a.estado === 'TARDANZA').length,
      faltas: asistencias.filter(a => a.estado === 'FALTA').length,
      justificadas: asistencias.filter(a => a.estado === 'JUSTIFICADA').length,
    };

    return {
      resumen,
      asistencias,
    };
  }

  async reportePorSeccion(seccionId: number, fechaInicio?: string, fechaFin?: string) {
    const where: any = {
      alumno: {
        seccionId,
      },
    };

    if (fechaInicio || fechaFin) {
      where.fecha = {};
      if (fechaInicio) {
        where.fecha.gte = new Date(fechaInicio);
      }
      if (fechaFin) {
        where.fecha.lte = new Date(fechaFin);
      }
    }

    const asistencias = await this.prisma.asistencia.findMany({
      where,
      include: {
        alumno: {
          include: {
            usuario: true,
          },
        },
        horario: {
          include: {
            curso: true,
          },
        },
      },
      orderBy: [
        { fecha: 'desc' },
        { alumno: { usuario: { apellidos: 'asc' } } },
      ],
    });

    // Agrupar por alumno
    const porAlumno = asistencias.reduce((acc, asistencia) => {
      const alumnoId = asistencia.alumnoId;
      if (!acc[alumnoId]) {
        acc[alumnoId] = {
          alumno: asistencia.alumno,
          asistencias: [],
          resumen: {
            total: 0,
            presentes: 0,
            tardanzas: 0,
            faltas: 0,
            justificadas: 0,
          },
        };
      }
      acc[alumnoId].asistencias.push(asistencia);
      acc[alumnoId].resumen.total++;
      if (asistencia.estado === 'PRESENTE') acc[alumnoId].resumen.presentes++;
      if (asistencia.estado === 'TARDANZA') acc[alumnoId].resumen.tardanzas++;
      if (asistencia.estado === 'FALTA') acc[alumnoId].resumen.faltas++;
      if (asistencia.estado === 'JUSTIFICADA') acc[alumnoId].resumen.justificadas++;
      return acc;
    }, {} as any);

    return {
      seccionId,
      totalAlumnos: Object.keys(porAlumno).length,
      porAlumno: Object.values(porAlumno),
    };
  }

  async reportePorCurso(cursoId: number, fechaInicio?: string, fechaFin?: string) {
    const where: any = {
      horario: {
        cursoId,
      },
    };

    if (fechaInicio || fechaFin) {
      where.fecha = {};
      if (fechaInicio) {
        where.fecha.gte = new Date(fechaInicio);
      }
      if (fechaFin) {
        where.fecha.lte = new Date(fechaFin);
      }
    }

    const asistencias = await this.prisma.asistencia.findMany({
      where,
      include: {
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
        horario: {
          include: {
            seccion: true,
          },
        },
      },
      orderBy: [
        { fecha: 'desc' },
        { alumno: { usuario: { apellidos: 'asc' } } },
      ],
    });

    const resumen = {
      total: asistencias.length,
      presentes: asistencias.filter(a => a.estado === 'PRESENTE').length,
      tardanzas: asistencias.filter(a => a.estado === 'TARDANZA').length,
      faltas: asistencias.filter(a => a.estado === 'FALTA').length,
      justificadas: asistencias.filter(a => a.estado === 'JUSTIFICADA').length,
    };

    return {
      cursoId,
      resumen,
      asistencias,
    };
  }
}

