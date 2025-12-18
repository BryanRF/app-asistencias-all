import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/horarios_service.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/widgets.dart';
import '../../asistencias/pages/tomar_asistencia_page.dart';

class HorariosPage extends StatefulWidget {
  final int profesorId;

  const HorariosPage({super.key, required this.profesorId});

  @override
  State<HorariosPage> createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  final _horariosService = HorariosService();
  List<dynamic> _horarios = [];
  bool _isLoading = true;
  int _selectedDia = DateTime.now().weekday;

  final List<String> _diasSemana = [
    '',
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _loadHorarios();
  }

  Future<void> _loadHorarios() async {
    try {
      setState(() => _isLoading = true);
      final response = await _horariosService.findByProfesor(widget.profesorId);
      setState(() {
        _horarios = response['data'] ?? [];
      });
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, e, errorContext: 'load_data');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<dynamic> _getHorariosDia(int dia) {
    return _horarios
        .where((h) => h['diaSemana'] == dia)
        .toList()
      ..sort((a, b) => (a['horaInicio'] as String).compareTo(b['horaInicio'] as String));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Horarios'),
      ),
      body: Column(
        children: [
          DaySelector(
            selectedDay: _selectedDia,
            onDaySelected: (day) => setState(() => _selectedDia = day),
            days: _diasSemana,
            maxDays: 5,
          ),
          const Divider(height: 1),
          // Lista de horarios
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadHorarios,
                    child: _buildHorariosList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorariosList() {
    final horariosDia = _getHorariosDia(_selectedDia);

    if (horariosDia.isEmpty) {
      return EmptyState(
        icon: Icons.calendar_today_outlined,
        title: 'No hay clases el ${_diasSemana[_selectedDia]}',
      );
    }

    final isMobile = Responsive.isMobile(context);
    
    return ListView.builder(
      padding: EdgeInsets.all(
        isMobile ? AppTheme.spacingSM : AppTheme.spacingMD,
      ),
      itemCount: horariosDia.length,
      itemBuilder: (context, index) {
        final horario = horariosDia[index];
        return CustomCard(
          margin: EdgeInsets.only(
            bottom: isMobile ? AppTheme.spacingSM : AppTheme.spacingMD,
          ),
          child: isMobile
              ? _buildMobileHorarioItem(context, horario)
              : _buildDesktopHorarioItem(context, horario),
        );
      },
    );
  }

  Widget _buildMobileHorarioItem(BuildContext context, dynamic horario) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TimeBadge(
                horaInicio: horario['horaInicio'] ?? '',
                horaFin: horario['horaFin'] ?? '',
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: Text(
                  horario['curso']?['nombre'] ?? 'Sin curso',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSM),
          InfoRow(
            icon: Icons.class_,
            text: '${horario['seccion']?['grado']?['nombre'] ?? ''} - ${horario['seccion']?['nombre'] ?? ''}',
          ),
          const SizedBox(height: AppTheme.spacingXS),
          InfoRow(
            icon: Icons.schedule,
            text: horario['turno']?['nombre'] ?? '',
          ),
          const SizedBox(height: AppTheme.spacingMD),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TomarAsistenciaPage(
                      horarioId: horario['id'],
                      nombreCurso: horario['curso']?['nombre'] ?? 'Curso',
                      nombreSeccion: '${horario['seccion']?['grado']?['nombre'] ?? ''} - ${horario['seccion']?['nombre'] ?? ''}',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.list_alt, size: 18),
              label: const Text('Tomar Asistencia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMD,
                  vertical: AppTheme.spacingMD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHorarioItem(BuildContext context, dynamic horario) {
    return ListTile(
      contentPadding: const EdgeInsets.all(AppTheme.spacingMD),
      leading: TimeBadge(
        horaInicio: horario['horaInicio'] ?? '',
        horaFin: horario['horaFin'] ?? '',
      ),
      title: Text(
        horario['curso']?['nombre'] ?? 'Sin curso',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingXS),
          InfoRow(
            icon: Icons.class_,
            text: '${horario['seccion']?['grado']?['nombre'] ?? ''} - ${horario['seccion']?['nombre'] ?? ''}',
          ),
          const SizedBox(height: AppTheme.spacingXS),
          InfoRow(
            icon: Icons.schedule,
            text: horario['turno']?['nombre'] ?? '',
          ),
        ],
      ),
      trailing: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TomarAsistenciaPage(
                horarioId: horario['id'],
                nombreCurso: horario['curso']?['nombre'] ?? 'Curso',
                nombreSeccion: '${horario['seccion']?['grado']?['nombre'] ?? ''} - ${horario['seccion']?['nombre'] ?? ''}',
              ),
            ),
          );
        },
        icon: const Icon(Icons.list_alt, size: 18),
        label: const Text('Asistencia'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMD,
            vertical: AppTheme.spacingSM,
          ),
        ),
      ),
    );
  }
}
