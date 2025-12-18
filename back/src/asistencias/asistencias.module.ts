import { Module } from '@nestjs/common';
import { AsistenciasService } from './asistencias.service';
import { AsistenciasController } from './asistencias.controller';
import { AsistenciasGateway } from './asistencias.gateway';

@Module({
  controllers: [AsistenciasController],
  providers: [AsistenciasService, AsistenciasGateway],
  exports: [AsistenciasService],
})
export class AsistenciasModule {}

