"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RolVO = exports.Rol = void 0;
var Rol;
(function (Rol) {
    Rol["ALUMNO"] = "ALUMNO";
    Rol["PROFESOR"] = "PROFESOR";
    Rol["ADMIN"] = "ADMIN";
})(Rol || (exports.Rol = Rol = {}));
class RolVO {
    static isValid(rol) {
        return Object.values(Rol).includes(rol);
    }
    static fromString(rol) {
        if (!this.isValid(rol)) {
            throw new Error(`Rol inválido: ${rol}`);
        }
        return rol;
    }
}
exports.RolVO = RolVO;
//# sourceMappingURL=rol.vo.js.map