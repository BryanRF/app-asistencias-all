"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthModule = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const passport_1 = require("@nestjs/passport");
const config_1 = require("@nestjs/config");
const prisma_module_1 = require("../../prisma/prisma.module");
const auth_controller_1 = require("../../presentation/controllers/auth.controller");
const login_use_case_1 = require("../../application/use-cases/login.use-case");
const validate_user_use_case_1 = require("../../application/use-cases/validate-user.use-case");
const prisma_usuario_repository_1 = require("../repositories/prisma-usuario.repository");
const jwt_strategy_1 = require("../../common/strategies/jwt.strategy");
let AuthModule = class AuthModule {
};
exports.AuthModule = AuthModule;
exports.AuthModule = AuthModule = __decorate([
    (0, common_1.Module)({
        imports: [
            prisma_module_1.PrismaModule,
            passport_1.PassportModule,
            jwt_1.JwtModule.registerAsync({
                imports: [config_1.ConfigModule],
                useFactory: async (configService) => ({
                    secret: configService.get('JWT_SECRET'),
                    signOptions: { expiresIn: '24h' },
                }),
                inject: [config_1.ConfigService],
            }),
        ],
        controllers: [auth_controller_1.AuthController],
        providers: [
            login_use_case_1.LoginUseCase,
            validate_user_use_case_1.ValidateUserUseCase,
            {
                provide: 'IUsuarioRepository',
                useClass: prisma_usuario_repository_1.PrismaUsuarioRepository,
            },
            jwt_strategy_1.JwtStrategy,
        ],
        exports: [
            'IUsuarioRepository',
            login_use_case_1.LoginUseCase,
            validate_user_use_case_1.ValidateUserUseCase,
            jwt_1.JwtModule,
        ],
    })
], AuthModule);
//# sourceMappingURL=auth.module.js.map