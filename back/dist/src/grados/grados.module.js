"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GradosModule = void 0;
const common_1 = require("@nestjs/common");
const grados_service_1 = require("./grados.service");
const grados_controller_1 = require("./grados.controller");
let GradosModule = class GradosModule {
};
exports.GradosModule = GradosModule;
exports.GradosModule = GradosModule = __decorate([
    (0, common_1.Module)({
        controllers: [grados_controller_1.GradosController],
        providers: [grados_service_1.GradosService],
        exports: [grados_service_1.GradosService],
    })
], GradosModule);
//# sourceMappingURL=grados.module.js.map