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
Object.defineProperty(exports, "__esModule", { value: true });
require("dotenv/config");
const client_1 = require("@prisma/client");
const adapter_mariadb_1 = require("@prisma/adapter-mariadb");
const bcrypt = __importStar(require("bcrypt"));
const dbUrl = new URL(process.env.DATABASE_URL.replace('mysql://', 'http://'));
const poolConfig = {
    host: dbUrl.hostname === 'localhost' ? '127.0.0.1' : dbUrl.hostname,
    port: parseInt(dbUrl.port) || 3306,
    user: decodeURIComponent(dbUrl.username),
    password: decodeURIComponent(dbUrl.password),
    database: dbUrl.pathname.slice(1),
};
const adapter = new adapter_mariadb_1.PrismaMariaDb(poolConfig);
const prisma = new client_1.PrismaClient({ adapter });
async function main() {
    console.log('🌱 Iniciando seeders...');
    console.log('🧹 Limpiando datos existentes...');
    await prisma.asistencia.deleteMany();
    await prisma.horario.deleteMany();
    await prisma.alumno.deleteMany();
    await prisma.profesor.deleteMany();
    await prisma.usuario.deleteMany();
    await prisma.curso.deleteMany();
    await prisma.seccion.deleteMany();
    await prisma.grado.deleteMany();
    await prisma.turno.deleteMany();
    const hashedPassword = await bcrypt.hash('123456', 10);
    console.log('📅 Creando turnos...');
    const turnoManana = await prisma.turno.create({
        data: {
            nombre: 'Mañana',
            horaInicio: '08:00',
            horaFin: '13:00',
        },
    });
    const turnoTarde = await prisma.turno.create({
        data: {
            nombre: 'Tarde',
            horaInicio: '14:00',
            horaFin: '19:00',
        },
    });
    console.log('📚 Creando grados de Primaria...');
    const gradosPrimaria = [];
    for (let i = 1; i <= 6; i++) {
        const grado = await prisma.grado.create({
            data: {
                nombre: `${i}° Primaria`,
                nivel: 'PRIMARIA',
            },
        });
        gradosPrimaria.push(grado);
    }
    console.log('📚 Creando grados de Secundaria...');
    const gradosSecundaria = [];
    for (let i = 1; i <= 5; i++) {
        const grado = await prisma.grado.create({
            data: {
                nombre: `${i}° Secundaria`,
                nivel: 'SECUNDARIA',
            },
        });
        gradosSecundaria.push(grado);
    }
    console.log('🏫 Creando secciones...');
    const secciones = [];
    for (const grado of [...gradosPrimaria, ...gradosSecundaria]) {
        for (const letra of ['A', 'B', 'C']) {
            const seccion = await prisma.seccion.create({
                data: {
                    nombre: letra,
                    gradoId: grado.id,
                },
            });
            secciones.push(seccion);
        }
    }
    console.log('📖 Creando cursos...');
    const cursosPrimaria = [
        { nombre: 'Matemática', codigo: 'MAT-PRI' },
        { nombre: 'Comunicación', codigo: 'COM-PRI' },
        { nombre: 'Ciencia y Ambiente', codigo: 'CYA-PRI' },
        { nombre: 'Personal Social', codigo: 'PS-PRI' },
        { nombre: 'Arte', codigo: 'ART-PRI' },
        { nombre: 'Educación Física', codigo: 'EF-PRI' },
        { nombre: 'Religión', codigo: 'REL-PRI' },
    ];
    const cursosSecundaria = [
        { nombre: 'Matemática', codigo: 'MAT-SEC' },
        { nombre: 'Comunicación', codigo: 'COM-SEC' },
        { nombre: 'Ciencia y Tecnología', codigo: 'CT-SEC' },
        { nombre: 'Historia, Geografía y Economía', codigo: 'HGE-SEC' },
        { nombre: 'Formación Ciudadana y Cívica', codigo: 'FCC-SEC' },
        { nombre: 'Inglés', codigo: 'ING-SEC' },
        { nombre: 'Arte y Cultura', codigo: 'AC-SEC' },
        { nombre: 'Educación Física', codigo: 'EF-SEC' },
        { nombre: 'Religión', codigo: 'REL-SEC' },
    ];
    const cursos = [];
    for (const grado of gradosPrimaria) {
        for (const cursoData of cursosPrimaria) {
            const curso = await prisma.curso.create({
                data: {
                    nombre: cursoData.nombre,
                    codigo: `${cursoData.codigo}-${grado.nombre.replace('°', '').replace(' ', '')}`,
                    gradoId: grado.id,
                },
            });
            cursos.push(curso);
        }
    }
    for (const grado of gradosSecundaria) {
        for (const cursoData of cursosSecundaria) {
            const curso = await prisma.curso.create({
                data: {
                    nombre: cursoData.nombre,
                    codigo: `${cursoData.codigo}-${grado.nombre.replace('°', '').replace(' ', '')}`,
                    gradoId: grado.id,
                },
            });
            cursos.push(curso);
        }
    }
    console.log('👨‍🏫 Creando profesores...');
    const profesores = [];
    const nombresProfesores = [
        { nombres: 'Juan', apellidos: 'Pérez García', dni: '12345678' },
        { nombres: 'María', apellidos: 'González López', dni: '23456789' },
        { nombres: 'Carlos', apellidos: 'Rodríguez Martínez', dni: '34567890' },
        { nombres: 'Ana', apellidos: 'Fernández Sánchez', dni: '45678901' },
        { nombres: 'Luis', apellidos: 'Torres Díaz', dni: '56789012' },
    ];
    for (let i = 0; i < nombresProfesores.length; i++) {
        const profData = nombresProfesores[i];
        const usuario = await prisma.usuario.create({
            data: {
                dni: profData.dni,
                nombres: profData.nombres,
                apellidos: profData.apellidos,
                email: `profesor${i + 1}@colegio.edu.pe`,
                password: hashedPassword,
                rol: 'PROFESOR',
            },
        });
        const profesor = await prisma.profesor.create({
            data: {
                usuarioId: usuario.id,
                codigo: `PROF${String(i + 1).padStart(3, '0')}`,
            },
        });
        profesores.push(profesor);
    }
    console.log('👨‍🎓 Creando alumnos...');
    const alumnos = [];
    let alumnoIndex = 1;
    for (const seccion of secciones.slice(0, 6)) {
        for (let i = 1; i <= 25; i++) {
            const dni = String(70000000 + alumnoIndex).padStart(8, '0');
            const usuario = await prisma.usuario.create({
                data: {
                    dni,
                    nombres: `Alumno${alumnoIndex}`,
                    apellidos: `Apellido${alumnoIndex}`,
                    email: `alumno${alumnoIndex}@colegio.edu.pe`,
                    password: hashedPassword,
                    rol: 'ALUMNO',
                },
            });
            const alumno = await prisma.alumno.create({
                data: {
                    usuarioId: usuario.id,
                    codigo: `AL${String(alumnoIndex).padStart(4, '0')}`,
                    seccionId: seccion.id,
                },
            });
            alumnos.push(alumno);
            alumnoIndex++;
        }
    }
    console.log('⏰ Creando horarios...');
    const diasSemana = [
        { dia: 1, nombre: 'Lunes' },
        { dia: 2, nombre: 'Martes' },
        { dia: 3, nombre: 'Miércoles' },
        { dia: 4, nombre: 'Jueves' },
        { dia: 5, nombre: 'Viernes' },
    ];
    const horas = [
        { inicio: '08:00', fin: '08:45' },
        { inicio: '08:45', fin: '09:30' },
        { inicio: '09:30', fin: '10:15' },
        { inicio: '10:30', fin: '11:15' },
        { inicio: '11:15', fin: '12:00' },
        { inicio: '12:00', fin: '12:45' },
    ];
    let horarioIndex = 0;
    for (const seccion of secciones.slice(0, 3)) {
        for (const dia of diasSemana) {
            let horaIndex = 0;
            for (const hora of horas) {
                const curso = cursos[horarioIndex % cursos.length];
                const profesor = profesores[horarioIndex % profesores.length];
                await prisma.horario.create({
                    data: {
                        diaSemana: dia.dia,
                        horaInicio: hora.inicio,
                        horaFin: hora.fin,
                        cursoId: curso.id,
                        seccionId: seccion.id,
                        turnoId: turnoManana.id,
                        profesorId: profesor.id,
                    },
                });
                horaIndex++;
                horarioIndex++;
            }
        }
    }
    console.log('👤 Creando usuario admin...');
    await prisma.usuario.create({
        data: {
            dni: '00000000',
            nombres: 'Admin',
            apellidos: 'Sistema',
            email: 'admin@colegio.edu.pe',
            password: hashedPassword,
            rol: 'ADMIN',
        },
    });
    console.log('✅ Seeders completados exitosamente!');
    console.log(`📊 Resumen:`);
    console.log(`   - Turnos: 2`);
    console.log(`   - Grados: ${gradosPrimaria.length + gradosSecundaria.length}`);
    console.log(`   - Secciones: ${secciones.length}`);
    console.log(`   - Cursos: ${cursos.length}`);
    console.log(`   - Profesores: ${profesores.length}`);
    console.log(`   - Alumnos: ${alumnos.length}`);
}
main()
    .catch((e) => {
    console.error('❌ Error en seeders:', e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=seed.js.map