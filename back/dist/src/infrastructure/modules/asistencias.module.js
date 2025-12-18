"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AsistenciasModule = void 0;
const common_1 = require("@nestjs/common");
const prisma_module_1 = require("../../prisma/prisma.module");
const asistencias_controller_1 = require("../../presentation/controllers/asistencias.controller");
const create_asistencia_use_case_1 = require("../../application/use-cases/create-asistencia.use-case");
const create_multiple_asistencias_use_case_1 = require("../../application/use-cases/create-multiple-asistencias.use-case");
const get_asistencias_use_case_1 = require("../../application/use-cases/get-asistencias.use-case");
const get_asistencias_by_horario_use_case_1 = require("../../application/use-cases/get-asistencias-by-horario.use-case");
const prisma_asistencia_repository_1 = require("../repositories/prisma-asistencia.repository");
let AsistenciasModule = class AsistenciasModule {
};
exports.AsistenciasModule = AsistenciasModule;
exports.AsistenciasModule = AsistenciasModule = __decorate([
    (0, common_1.Module)({
        imports: [prisma_module_1.PrismaModule],
        controllers: [asistencias_controller_1.AsistenciasController],
        providers: [
            create_asistencia_use_case_1.CreateAsistenciaUseCase,
            create_multiple_asistencias_use_case_1.CreateMultipleAsistenciasUseCase,
            get_asistencias_use_case_1.GetAsistenciasUseCase,
            get_asistencias_by_horario_use_case_1.GetAsistenciasByHorarioUseCase,
            {
                provide: 'IAsistenciaRepository',
                useClass: prisma_asistencia_repository_1.PrismaAsistenciaRepository,
            },
        ],
        exports: [
            'IAsistenciaRepository',
            create_asistencia_use_case_1.CreateAsistenciaUseCase,
            create_multiple_asistencias_use_case_1.CreateMultipleAsistenciasUseCase,
            get_asistencias_use_case_1.GetAsistenciasUseCase,
            get_asistencias_by_horario_use_case_1.GetAsistenciasByHorarioUseCase,
        ],
    })
], AsistenciasModule);
//# sourceMappingURL=asistencias.module.js.map