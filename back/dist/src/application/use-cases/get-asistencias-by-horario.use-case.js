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
exports.GetAsistenciasByHorarioUseCase = void 0;
const common_1 = require("@nestjs/common");
const asistencia_repository_1 = require("../../domain/repositories/asistencia.repository");
let GetAsistenciasByHorarioUseCase = class GetAsistenciasByHorarioUseCase {
    asistenciaRepository;
    constructor(asistenciaRepository) {
        this.asistenciaRepository = asistenciaRepository;
    }
    async execute(input) {
        const fecha = new Date(input.fecha);
        return this.asistenciaRepository.findByHorarioAndFecha(input.horarioId, fecha);
    }
};
exports.GetAsistenciasByHorarioUseCase = GetAsistenciasByHorarioUseCase;
exports.GetAsistenciasByHorarioUseCase = GetAsistenciasByHorarioUseCase = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, common_1.Inject)('IAsistenciaRepository')),
    __metadata("design:paramtypes", [asistencia_repository_1.IAsistenciaRepository])
], GetAsistenciasByHorarioUseCase);
//# sourceMappingURL=get-asistencias-by-horario.use-case.js.map