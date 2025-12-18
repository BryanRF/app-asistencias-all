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
exports.CreateAsistenciaUseCase = void 0;
const common_1 = require("@nestjs/common");
const asistencia_repository_1 = require("../../domain/repositories/asistencia.repository");
const asistencia_entity_1 = require("../../domain/entities/asistencia.entity");
let CreateAsistenciaUseCase = class CreateAsistenciaUseCase {
    asistenciaRepository;
    constructor(asistenciaRepository) {
        this.asistenciaRepository = asistenciaRepository;
    }
    async execute(input) {
        const fecha = new Date(input.fecha);
        const estado = input.estado;
        const existente = await this.asistenciaRepository.findByUniqueConstraint(fecha, input.horarioId, input.alumnoId);
        if (existente) {
            throw new common_1.BadRequestException('Ya existe una asistencia registrada para este alumno en esta fecha y horario');
        }
        const asistencia = asistencia_entity_1.Asistencia.create({
            fecha,
            estado,
            observacion: input.observacion,
            horarioId: input.horarioId,
            alumnoId: input.alumnoId,
        });
        const saved = await this.asistenciaRepository.create(asistencia);
        return {
            id: saved.id,
            fecha: saved.fecha,
            estado: saved.estado,
            observacion: saved.observacion,
            horarioId: saved.horarioId,
            alumnoId: saved.alumnoId,
        };
    }
};
exports.CreateAsistenciaUseCase = CreateAsistenciaUseCase;
exports.CreateAsistenciaUseCase = CreateAsistenciaUseCase = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, common_1.Inject)('IAsistenciaRepository')),
    __metadata("design:paramtypes", [asistencia_repository_1.IAsistenciaRepository])
], CreateAsistenciaUseCase);
//# sourceMappingURL=create-asistencia.use-case.js.map