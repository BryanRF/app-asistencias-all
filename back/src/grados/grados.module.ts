import { Module } from '@nestjs/common';
import { GradosService } from './grados.service';
import { GradosController } from './grados.controller';

@Module({
  controllers: [GradosController],
  providers: [GradosService],
  exports: [GradosService],
})
export class GradosModule {}

