import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { JwtService } from '@nestjs/jwt';
import { AsistenciasService } from './asistencias.service';
import { CreateMultipleAsistenciaDto } from './dto/create-asistencia.dto';
export declare class AsistenciasGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private asistenciasService;
    private jwtService;
    server: Server;
    constructor(asistenciasService: AsistenciasService, jwtService: JwtService);
    handleConnection(client: Socket): Promise<void>;
    handleDisconnect(client: Socket): void;
    handleJoinHorario(client: Socket, data: {
        horarioId: number;
    }): void;
    handleLeaveHorario(client: Socket, data: {
        horarioId: number;
    }): void;
    handleRegistrarAsistencias(client: Socket, data: CreateMultipleAsistenciaDto): Promise<void>;
    handleObtenerAsistencias(client: Socket, data: {
        horarioId: number;
        fecha: string;
    }): Promise<void>;
}
