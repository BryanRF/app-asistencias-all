"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LoginUseCase = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const bcrypt = __importStar(require("bcrypt"));
const usuario_repository_1 = require("../../domain/repositories/usuario.repository");
let LoginUseCase = class LoginUseCase {
    usuarioRepository;
    jwtService;
    constructor(usuarioRepository, jwtService) {
        this.usuarioRepository = usuarioRepository;
        this.jwtService = jwtService;
    }
    async execute(input) {
        const usuario = await this.usuarioRepository.findByDniWithRelations(input.dni);
        if (!usuario || !usuario.activo) {
            throw new common_1.UnauthorizedException('Credenciales inválidas');
        }
        const isPasswordValid = await bcrypt.compare(input.password, usuario.password);
        if (!isPasswordValid) {
            throw new common_1.UnauthorizedException('Credenciales inválidas');
        }
        const payload = {
            sub: usuario.id,
            dni: usuario.dni,
            rol: usuario.rol,
        };
        return {
            access_token: this.jwtService.sign(payload),
            user: {
                id: usuario.id,
                dni: usuario.dni,
                nombres: usuario.nombres,
                apellidos: usuario.apellidos,
                email: usuario.email ?? '',
                rol: usuario.rol,
            },
        };
    }
};
exports.LoginUseCase = LoginUseCase;
exports.LoginUseCase = LoginUseCase = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, common_1.Inject)('IUsuarioRepository')),
    __metadata("design:paramtypes", [usuario_repository_1.IUsuarioRepository,
        jwt_1.JwtService])
], LoginUseCase);
//# sourceMappingURL=login.use-case.js.map