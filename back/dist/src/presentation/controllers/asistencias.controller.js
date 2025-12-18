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
const jwt_auth_guard_1 = require("../../common/guards/jwt-auth.guard");
const roles_decorator_1 = require("../../common/decorators/roles.decorator");
const roles_guard_1 = require("../../common/guards/roles.guard");
const create_asistencia_use_case_1 = require("../../application/use-cases/create-asistencia.use-case");
const create_multiple_asistencias_use_case_1 = require("../../application/use-cases/create-multiple-asistencias.use-case");
const get_asistencias_use_case_1 = require("../../application/use-cases/get-asistencias.use-case");
const get_asistencias_by_horario_use_case_1 = require("../../application/use-cases/get-asistencias-by-horario.use-case");
const create_asistencia_dto_1 = require("./dto/create-asistencia.dto");
const pagination_dto_1 = require("../../common/dto/pagination.dto");
let AsistenciasController = class AsistenciasController {
    createAsistenciaUseCase;
    createMultipleAsistenciasUseCase;
    getAsistenciasUseCase;
    getAsistenciasByHorarioUseCase;
    constructor(createAsistenciaUseCase, createMultipleAsistenciasUseCase, getAsistenciasUseCase, getAsistenciasByHorarioUseCase) {
        this.createAsistenciaUseCase = createAsistenciaUseCase;
        this.createMultipleAsistenciasUseCase = createMultipleAsistenciasUseCase;
        this.getAsistenciasUseCase = getAsistenciasUseCase;
        this.getAsistenciasByHorarioUseCase = getAsistenciasByHorarioUseCase;
    }
    create(createAsistenciaDto) {
        return this.createAsistenciaUseCase.execute({
            fecha: createAsistenciaDto.fecha,
            estado: createAsistenciaDto.estado,
            observacion: createAsistenciaDto.observacion,
            horarioId: createAsistenciaDto.horarioId,
            alumnoId: createAsistenciaDto.alumnoId,
        });
    }
    createMultiple(createMultipleDto) {
        return this.createMultipleAsistenciasUseCase.execute({
            fecha: createMultipleDto.fecha,
            horarioId: createMultipleDto.horarioId,
            asistencias: createMultipleDto.asistencias,
        });
    }
    findAll(pagination, fechaInicio, fechaFin, horarioId, alumnoId, seccionId, req) {
        let filteredAlumnoId = alumnoId ? parseInt(alumnoId.toString()) : undefined;
        if (req?.user?.rol === 'ALUMNO' && req?.user?.alumno?.id) {
            filteredAlumnoId = req.user.alumno.id;
        }
        return this.getAsistenciasUseCase.execute({
            page: pagination.page,
            limit: pagination.limit,
            fechaInicio,
            fechaFin,
            horarioId: horarioId ? parseInt(horarioId.toString()) : undefined,
            alumnoId: filteredAlumnoId,
            seccionId: seccionId ? parseInt(seccionId.toString()) : undefined,
        });
    }
    getByHorarioAndFecha(horarioId, fecha) {
        return this.getAsistenciasByHorarioUseCase.execute({ horarioId, fecha });
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
exports.AsistenciasController = AsistenciasController = __decorate([
    (0, common_1.Controller)('asistencias'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [create_asistencia_use_case_1.CreateAsistenciaUseCase,
        create_multiple_asistencias_use_case_1.CreateMultipleAsistenciasUseCase,
        get_asistencias_use_case_1.GetAsistenciasUseCase,
        get_asistencias_by_horario_use_case_1.GetAsistenciasByHorarioUseCase])
], AsistenciasController);
//# sourceMappingURL=asistencias.controller.js.map