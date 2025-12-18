"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const core_1 = require("@nestjs/core");
const common_2 = require("@nestjs/common");
const config_module_1 = require("./config/config.module");
const prisma_module_1 = require("./prisma/prisma.module");
const auth_module_1 = require("./infrastructure/modules/auth.module");
const asistencias_module_1 = require("./infrastructure/modules/asistencias.module");
const grados_module_1 = require("./grados/grados.module");
const secciones_module_1 = require("./secciones/secciones.module");
const turnos_module_1 = require("./turnos/turnos.module");
const cursos_module_1 = require("./cursos/cursos.module");
const horarios_module_1 = require("./horarios/horarios.module");
const reportes_module_1 = require("./reportes/reportes.module");
const jwt_auth_guard_1 = require("./common/guards/jwt-auth.guard");
const http_exception_filter_1 = require("./common/filters/http-exception.filter");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_module_1.ConfigModule,
            prisma_module_1.PrismaModule,
            auth_module_1.AuthModule,
            asistencias_module_1.AsistenciasModule,
            grados_module_1.GradosModule,
            secciones_module_1.SeccionesModule,
            turnos_module_1.TurnosModule,
            cursos_module_1.CursosModule,
            horarios_module_1.HorariosModule,
            reportes_module_1.ReportesModule,
        ],
        providers: [
            {
                provide: core_1.APP_GUARD,
                useClass: jwt_auth_guard_1.JwtAuthGuard,
            },
            {
                provide: core_1.APP_FILTER,
                useClass: http_exception_filter_1.HttpExceptionFilter,
            },
            {
                provide: core_1.APP_PIPE,
                useClass: common_2.ValidationPipe,
            },
        ],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map