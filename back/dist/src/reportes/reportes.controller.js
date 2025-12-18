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
exports.ReportesController = void 0;
const common_1 = require("@nestjs/common");
const reportes_service_1 = require("./reportes.service");
const jwt_auth_guard_1 = require("../common/guards/jwt-auth.guard");
const roles_decorator_1 = require("../common/decorators/roles.decorator");
const roles_guard_1 = require("../common/guards/roles.guard");
let ReportesController = class ReportesController {
    reportesService;
    constructor(reportesService) {
        this.reportesService = reportesService;
    }
    reportePorAlumno(alumnoId, fechaInicio, fechaFin, req) {
        if (req?.user?.rol === 'ALUMNO' && req?.user?.alumno?.id !== alumnoId) {
            throw new Error('No autorizado');
        }
        return this.reportesService.reportePorAlumno(alumnoId, fechaInicio, fechaFin);
    }
    reportePorSeccion(seccionId, fechaInicio, fechaFin) {
        return this.reportesService.reportePorSeccion(seccionId, fechaInicio, fechaFin);
    }
    reportePorCurso(cursoId, fechaInicio, fechaFin) {
        return this.reportesService.reportePorCurso(cursoId, fechaInicio, fechaFin);
    }
};
exports.ReportesController = ReportesController;
__decorate([
    (0, common_1.Get)('alumno/:alumnoId'),
    (0, roles_decorator_1.Roles)('ADMIN', 'PROFESOR', 'ALUMNO'),
    __param(0, (0, common_1.Param)('alumnoId', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Query)('fechaInicio')),
    __param(2, (0, common_1.Query)('fechaFin')),
    __param(3, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String, String, Object]),
    __metadata("design:returntype", void 0)
], ReportesController.prototype, "reportePorAlumno", null);
__decorate([
    (0, common_1.Get)('seccion/:seccionId'),
    (0, roles_decorator_1.Roles)('ADMIN', 'PROFESOR'),
    __param(0, (0, common_1.Param)('seccionId', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Query)('fechaInicio')),
    __param(2, (0, common_1.Query)('fechaFin')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String, String]),
    __metadata("design:returntype", void 0)
], ReportesController.prototype, "reportePorSeccion", null);
__decorate([
    (0, common_1.Get)('curso/:cursoId'),
    (0, roles_decorator_1.Roles)('ADMIN', 'PROFESOR'),
    __param(0, (0, common_1.Param)('cursoId', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Query)('fechaInicio')),
    __param(2, (0, common_1.Query)('fechaFin')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String, String]),
    __metadata("design:returntype", void 0)
], ReportesController.prototype, "reportePorCurso", null);
exports.ReportesController = ReportesController = __decorate([
    (0, common_1.Controller)('reportes'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [reportes_service_1.ReportesService])
], ReportesController);
//# sourceMappingURL=reportes.controller.js.map