"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AsistenciasGateway = void 0;
const websockets_1 = require("@nestjs/websockets");
const socket_io_1 = require("socket.io");
const jwt_1 = require("@nestjs/jwt");
const asistencias_service_1 = require("./asistencias.service");
const create_asistencia_dto_1 = require("./dto/create-asistencia.dto");
let AsistenciasGateway = class AsistenciasGateway {
    asistenciasService;
    jwtService;
    server;
    constructor(asistenciasService, jwtService) {
        this.asistenciasService = asistenciasService;
        this.jwtService = jwtService;
    }
    async handleConnection(client) {
        try {
            const token = client.handshake.auth?.token || client.handshake.headers?.authorization?.split(' ')[1];
            if (token) {
                const payload = this.jwtService.verify(token);
                client.data.user = payload;
            }
        }
        catch (error) {
            client.disconnect();
        }
    }
    handleDisconnect(client) {
        console.log(`Cliente desconectado: ${client.id}`);
    }
    handleJoinHorario(client, data) {
        client.join(`horario-${data.horarioId}`);
        client.emit('joined', { horarioId: data.horarioId });
    }
    handleLeaveHorario(client, data) {
        client.leave(`horario-${data.horarioId}`);
    }
    async handleRegistrarAsistencias(client, data) {
        try {
            const resultado = await this.asistenciasService.createMultiple(data);
            this.server.to(`horario-${data.horarioId}`).emit('asistencias-registradas', {
                fecha: data.fecha,
                horarioId: data.horarioId,
                resultado,
            });
            client.emit('asistencias-registradas-success', resultado);
        }
        catch (error) {
            client.emit('error', { message: error.message });
        }
    }
    async handleObtenerAsistencias(client, data) {
        try {
            const asistencias = await this.asistenciasService.getByHorarioAndFecha(data.horarioId, data.fecha);
            client.emit('asistencias-obtenidas', { asistencias });
        }
        catch (error) {
            client.emit('error', { message: error.message });
        }
    }
};
exports.AsistenciasGateway = AsistenciasGateway;
__decorate([
    (0, websockets_1.WebSocketServer)(),
    __metadata("design:type", socket_io_1.Server)
], AsistenciasGateway.prototype, "server", void 0);
__decorate([
    (0, websockets_1.SubscribeMessage)('join-horario'),
    __param(0, (0, websockets_1.ConnectedSocket)()),
    __param(1, (0, websockets_1.MessageBody)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [socket_io_1.Socket, Object]),
    __metadata("design:returntype", void 0)
], AsistenciasGateway.prototype, "handleJoinHorario", null);
__decorate([
    (0, websockets_1.SubscribeMessage)('leave-horario'),
    __param(0, (0, websockets_1.ConnectedSocket)()),
    __param(1, (0, websockets_1.MessageBody)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [socket_io_1.Socket, Object]),
    __metadata("design:returntype", void 0)
], AsistenciasGateway.prototype, "handleLeaveHorario", null);
__decorate([
    (0, websockets_1.SubscribeMessage)('registrar-asistencias'),
    __param(0, (0, websockets_1.ConnectedSocket)()),
    __param(1, (0, websockets_1.MessageBody)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [socket_io_1.Socket,
        create_asistencia_dto_1.CreateMultipleAsistenciaDto]),
    __metadata("design:returntype", Promise)
], AsistenciasGateway.prototype, "handleRegistrarAsistencias", null);
__decorate([
    (0, websockets_1.SubscribeMessage)('obtener-asistencias'),
    __param(0, (0, websockets_1.ConnectedSocket)()),
    __param(1, (0, websockets_1.MessageBody)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [socket_io_1.Socket, Object]),
    __metadata("design:returntype", Promise)
], AsistenciasGateway.prototype, "handleObtenerAsistencias", null);
exports.AsistenciasGateway = AsistenciasGateway = __decorate([
    (0, websockets_1.WebSocketGateway)({
        cors: {
            origin: '*',
        },
    }),
    __metadata("design:paramtypes", [asistencias_service_1.AsistenciasService,
        jwt_1.JwtService])
], AsistenciasGateway);
//# sourceMappingURL=asistencias.gateway.js.map