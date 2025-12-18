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
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateMultipleAsistenciaDto = exports.AsistenciaItemDto = exports.CreateAsistenciaDto = void 0;
const class_validator_1 = require("class-validator");
const class_transformer_1 = require("class-transformer");
const estado_asistencia_vo_1 = require("../../../domain/value-objects/estado-asistencia.vo");
class CreateAsistenciaDto {
    fecha;
    estado;
    observacion;
    horarioId;
    alumnoId;
}
exports.CreateAsistenciaDto = CreateAsistenciaDto;
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateAsistenciaDto.prototype, "fecha", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(estado_asistencia_vo_1.EstadoAsistencia),
    __metadata("design:type", String)
], CreateAsistenciaDto.prototype, "estado", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreateAsistenciaDto.prototype, "observacion", void 0);
__decorate([
    (0, class_validator_1.IsInt)(),
    __metadata("design:type", Number)
], CreateAsistenciaDto.prototype, "horarioId", void 0);
__decorate([
    (0, class_validator_1.IsInt)(),
    __metadata("design:type", Number)
], CreateAsistenciaDto.prototype, "alumnoId", void 0);
class AsistenciaItemDto {
    alumnoId;
    estado;
    observacion;
}
exports.AsistenciaItemDto = AsistenciaItemDto;
__decorate([
    (0, class_validator_1.IsInt)(),
    __metadata("design:type", Number)
], AsistenciaItemDto.prototype, "alumnoId", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(estado_asistencia_vo_1.EstadoAsistencia),
    __metadata("design:type", String)
], AsistenciaItemDto.prototype, "estado", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], AsistenciaItemDto.prototype, "observacion", void 0);
class CreateMultipleAsistenciaDto {
    fecha;
    horarioId;
    asistencias;
}
exports.CreateMultipleAsistenciaDto = CreateMultipleAsistenciaDto;
__decorate([
    (0, class_validator_1.IsDateString)(),
    __metadata("design:type", String)
], CreateMultipleAsistenciaDto.prototype, "fecha", void 0);
__decorate([
    (0, class_validator_1.IsInt)(),
    __metadata("design:type", Number)
], CreateMultipleAsistenciaDto.prototype, "horarioId", void 0);
__decorate([
    (0, class_validator_1.IsArray)(),
    (0, class_validator_1.ValidateNested)({ each: true }),
    (0, class_transformer_1.Type)(() => AsistenciaItemDto),
    __metadata("design:type", Array)
], CreateMultipleAsistenciaDto.prototype, "asistencias", void 0);
//# sourceMappingURL=create-asistencia.dto.js.map