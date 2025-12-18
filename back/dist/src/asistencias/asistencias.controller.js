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
exports.AsistenciasController = void 0;
const common_1 = require("@nestjs/common");
const asistencias_service_1 = require("./asistencias.service");
const create_asistencia_dto_1 = require("./dto/create-asistencia.dto");
const pagination_dto_1 = require("../common/dto/pagination.dto");
const jwt_auth_guard_1 = require("../common/guards/jwt-auth.guard");
const roles_decorator_1 = require("../common/decorators/roles.decorator");
const roles_guard_1 = require("../common/guards/roles.guard");
let AsistenciasController = class AsistenciasController {
    asistenciasService;
    constructor(asistenciasService) {
        this.asistenciasService = asistenciasService;
    }
    create(createAsistenciaDto) {
        return this.asistenciasService.create(createAsistenciaDto);
    }
    createMultiple(createMultipleDto) {
        return this.asistenciasService.createMultiple(createMultipleDto);
    }
    findAll(pagination, fechaInicio, fechaFin, horarioId, alumnoId, seccionId, req) {
        const filters = {};
        if (fechaInicio)
            filters.fechaInicio = fechaInicio;
        if (fechaFin)
            filters.fechaFin = fechaFin;
        if (horarioId)
            filters.horarioId = parseInt(horarioId.toString());
        if (alumnoId)
            filters.alumnoId = parseInt(alumnoId.toString());
        if (seccionId)
            filters.seccionId = parseInt(seccionId.toString());
        if (req?.user?.rol === 'ALUMNO' && req?.user?.alumno?.id) {
            filters.alumnoId = req.user.alumno.id;
        }
        return this.asistenciasService.findAll(pagination, filters);
    }
    getByHorarioAndFecha(horarioId, fecha) {
        return this.asistenciasService.getByHorarioAndFecha(horarioId, fecha);
    }
    findOne(id) {
        return this.asistenciasService.findOne(id);
    }
};
exports.AsistenciasController = AsistenciasController;
__decorate([
    (0, common_1.Post)(),
    (0, roles_decorator_1.Roles)('PROFESOR', 'ADMIN'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_asistencia_dto_1.CreateAsistenciaDto]),
    __metadata("design:returntype", void 0)
], AsistenciasController.prototype, "create", null);
__decorate([
    (0, common_1.Post)('multiple'),
    (0, roles_decorator_1.Roles)('PROFESOR', 'ADMIN'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_asistencia_dto_1.CreateMultipleAsistenciaDto]),
    __metadata("design:returntype", void 0)
], AsistenciasController.prototype, "createMultiple", null);
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Query)()),
    __param(1, (0, common_1.Query)('fechaInicio')),
    __param(2, (0, common_1.Query)('fechaFin')),
    __param(3, (0, common_1.Query)('horarioId')),
    __param(4, (0, common_1.Query)('alumnoId')),
    __param(5, (0, common_1.Query)('seccionId')),
    __param(6, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [pagination_dto_1.PaginationDto, String, String, Number, Number, Number, Object]),
    __metadata("design:returntype", void 0)
], AsistenciasController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('horario/:horarioId/fecha/:fecha'),
    __param(0, (0, common_1.Param)('horarioId', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Param)('fecha')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String]),
    __metadata("design:returntype", void 0)
], AsistenciasController.prototype, "getByHorarioAndFecha", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", void 0)
], AsistenciasController.prototype, "findOne", null);
exports.AsistenciasController = AsistenciasController = __decorate([
    (0, common_1.Controller)('asistencias'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [asistencias_service_1.AsistenciasService])
], AsistenciasController);
//# sourceMappingURL=asistencias.controller.js.map