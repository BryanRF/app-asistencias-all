import { PrismaService } from '../prisma/prisma.service';
import { CreateTurnoDto } from './dto/create-turno.dto';
import { PaginationDto, PaginatedResponse } from '../common/dto/pagination.dto';
export declare class TurnosService {
    private prisma;
    constructor(prisma: PrismaService);
    create(createTurnoDto: CreateTurnoDto): Promise<{
        nombre: string;
        horaInicio: string;
        horaFin: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
    }>;
    findAll(pagination: PaginationDto): Promise<PaginatedResponse<any>>;
    findOne(id: number): Promise<{
        nombre: string;
        horaInicio: string;
        horaFin: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
    } | null>;
}
