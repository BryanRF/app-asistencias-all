-- CreateTable
CREATE TABLE `usuarios` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `dni` VARCHAR(8) NOT NULL,
    `nombres` VARCHAR(100) NOT NULL,
    `apellidos` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NULL,
    `password` VARCHAR(255) NOT NULL,
    `rol` ENUM('ALUMNO', 'PROFESOR', 'ADMIN') NOT NULL DEFAULT 'ALUMNO',
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `usuarios_dni_key`(`dni`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `grados` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `nivel` ENUM('PRIMARIA', 'SECUNDARIA') NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `secciones` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(10) NOT NULL,
    `gradoId` INTEGER NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `secciones_gradoId_nombre_key`(`gradoId`, `nombre`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `turnos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `horaInicio` VARCHAR(5) NOT NULL,
    `horaFin` VARCHAR(5) NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cursos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100) NOT NULL,
    `codigo` VARCHAR(20) NOT NULL,
    `gradoId` INTEGER NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `cursos_codigo_key`(`codigo`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `horarios` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `diaSemana` INTEGER NOT NULL,
    `horaInicio` VARCHAR(5) NOT NULL,
    `horaFin` VARCHAR(5) NOT NULL,
    `cursoId` INTEGER NOT NULL,
    `seccionId` INTEGER NOT NULL,
    `turnoId` INTEGER NOT NULL,
    `profesorId` INTEGER NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `alumnos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `usuarioId` INTEGER NOT NULL,
    `codigo` VARCHAR(20) NOT NULL,
    `seccionId` INTEGER NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `alumnos_usuarioId_key`(`usuarioId`),
    UNIQUE INDEX `alumnos_codigo_key`(`codigo`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `profesores` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `usuarioId` INTEGER NOT NULL,
    `codigo` VARCHAR(20) NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `profesores_usuarioId_key`(`usuarioId`),
    UNIQUE INDEX `profesores_codigo_key`(`codigo`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `asistencias` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha` DATE NOT NULL,
    `estado` ENUM('PRESENTE', 'TARDANZA', 'FALTA', 'JUSTIFICADA') NOT NULL,
    `observacion` TEXT NULL,
    `horarioId` INTEGER NOT NULL,
    `alumnoId` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `asistencias_fecha_horarioId_alumnoId_key`(`fecha`, `horarioId`, `alumnoId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `secciones` ADD CONSTRAINT `secciones_gradoId_fkey` FOREIGN KEY (`gradoId`) REFERENCES `grados`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cursos` ADD CONSTRAINT `cursos_gradoId_fkey` FOREIGN KEY (`gradoId`) REFERENCES `grados`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `horarios` ADD CONSTRAINT `horarios_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `cursos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `horarios` ADD CONSTRAINT `horarios_seccionId_fkey` FOREIGN KEY (`seccionId`) REFERENCES `secciones`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `horarios` ADD CONSTRAINT `horarios_turnoId_fkey` FOREIGN KEY (`turnoId`) REFERENCES `turnos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `horarios` ADD CONSTRAINT `horarios_profesorId_fkey` FOREIGN KEY (`profesorId`) REFERENCES `profesores`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alumnos` ADD CONSTRAINT `alumnos_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alumnos` ADD CONSTRAINT `alumnos_seccionId_fkey` FOREIGN KEY (`seccionId`) REFERENCES `secciones`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `profesores` ADD CONSTRAINT `profesores_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `asistencias` ADD CONSTRAINT `asistencias_horarioId_fkey` FOREIGN KEY (`horarioId`) REFERENCES `horarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `asistencias` ADD CONSTRAINT `asistencias_alumnoId_fkey` FOREIGN KEY (`alumnoId`) REFERENCES `alumnos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
