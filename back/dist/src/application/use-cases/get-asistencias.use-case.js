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
exports.GetAsistenciasUseCase = void 0;
const common_1 = require("@nestjs/common");
const asistencia_repository_1 = require("../../domain/repositories/asistencia.repository");
let GetAsistenciasUseCase = class GetAsistenciasUseCase {
    asistenciaRepository;
    constructor(asistenciaRepository) {
        this.asistenciaRepository = asistenciaRepository;
    }
    async execute(input) {
        const pagination = {
            page: input.page || 1,
            limit: input.limit || 10,
        };
        const filters = {};
        if (input.fechaInicio) {
            filters.fechaInicio = new Date(input.fechaInicio);
        }
        if (input.fechaFin) {
            filters.fechaFin = new Date(input.fechaFin);
        }
        if (input.horarioId) {
            filters.horarioId = input.horarioId;
        }
        if (input.alumnoId) {
            filters.alumnoId = input.alumnoId;
        }
        if (input.seccionId) {
            filters.seccionId = input.seccionId;
        }
        return this.asistenciaRepository.findAll(pagination, filters);
    }
};
exports.GetAsistenciasUseCase = GetAsistenciasUseCase;
exports.GetAsistenciasUseCase = GetAsistenciasUseCase = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, common_1.Inject)('IAsistenciaRepository')),
    __metadata("design:paramtypes", [asistencia_repository_1.IAsistenciaRepository])
], GetAsistenciasUseCase);
//# sourceMappingURL=get-asistencias.use-case.js.map