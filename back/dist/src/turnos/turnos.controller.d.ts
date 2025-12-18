import { TurnosService } from './turnos.service';
import { CreateTurnoDto } from './dto/create-turno.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
export declare class TurnosController {
    private readonly turnosService;
    constructor(turnosService: TurnosService);
    create(createTurnoDto: CreateTurnoDto): Promise<{
        nombre: string;
        horaInicio: string;
        horaFin: string;
        activo: boolean;
        createdAt: Date;
        updatedAt: Date;
        id: number;
    }>;
    findAll(pagination: PaginationDto): Promise<import("../common/dto/pagination.dto").PaginatedResponse<any>>;
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
