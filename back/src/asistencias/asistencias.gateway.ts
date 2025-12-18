import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  MessageBody,
  ConnectedSocket,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { UseGuards } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AsistenciasService } from './asistencias.service';
import { CreateMultipleAsistenciaDto } from './dto/create-asistencia.dto';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class AsistenciasGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(
    private asistenciasService: AsistenciasService,
    private jwtService: JwtService,
  ) {}

  async handleConnection(client: Socket) {
    try {
      const token = client.handshake.auth?.token || client.handshake.headers?.authorization?.split(' ')[1];
      if (token) {
        const payload = this.jwtService.verify(token);
        client.data.user = payload;
      }
    } catch (error) {
      client.disconnect();
    }
  }

  handleDisconnect(client: Socket) {
    console.log(`Cliente desconectado: ${client.id}`);
  }

  @SubscribeMessage('join-horario')
  handleJoinHorario(@ConnectedSocket() client: Socket, @MessageBody() data: { horarioId: number }) {
    client.join(`horario-${data.horarioId}`);
    client.emit('joined', { horarioId: data.horarioId });
  }

  @SubscribeMessage('leave-horario')
  handleLeaveHorario(@ConnectedSocket() client: Socket, @MessageBody() data: { horarioId: number }) {
    client.leave(`horario-${data.horarioId}`);
  }

  @SubscribeMessage('registrar-asistencias')
  async handleRegistrarAsistencias(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: CreateMultipleAsistenciaDto,
  ) {
    try {
      const resultado = await this.asistenciasService.createMultiple(data);
      
      // Emitir a todos los clientes conectados al horario
      this.server.to(`horario-${data.horarioId}`).emit('asistencias-registradas', {
        fecha: data.fecha,
        horarioId: data.horarioId,
        resultado,
      });

      client.emit('asistencias-registradas-success', resultado);
    } catch (error) {
      client.emit('error', { message: error.message });
    }
  }

  @SubscribeMessage('obtener-asistencias')
  async handleObtenerAsistencias(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { horarioId: number; fecha: string },
  ) {
    try {
      const asistencias = await this.asistenciasService.getByHorarioAndFecha(data.horarioId, data.fecha);
      client.emit('asistencias-obtenidas', { asistencias });
    } catch (error) {
      client.emit('error', { message: error.message });
    }
  }
}

