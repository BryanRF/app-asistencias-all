import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor() {
    // Prisma 7 requiere adaptadores de driver
    // Parsear DATABASE_URL para crear la configuración del adaptador
    const dbUrl = new URL(process.env.DATABASE_URL!.replace('mysql://', 'http://'));
    const poolConfig = {
      host: dbUrl.hostname === 'localhost' ? '127.0.0.1' : dbUrl.hostname,
      port: parseInt(dbUrl.port) || 3306,
      user: decodeURIComponent(dbUrl.username),
      password: decodeURIComponent(dbUrl.password),
      database: dbUrl.pathname.slice(1),
    };

    const adapter = new PrismaMariaDb(poolConfig);
    super({ adapter });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
