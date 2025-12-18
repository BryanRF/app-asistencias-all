import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/horarios_service.dart';
import '../../../core/services/asistencias_service.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/widgets.dart';

class TomarAsistenciaPage extends StatefulWidget {
  final int horarioId;
  final String nombreCurso;
  final String nombreSeccion;

  const TomarAsistenciaPage({
    super.key,
    required this.horarioId,
    required this.nombreCurso,
    required this.nombreSeccion,
  });

  @override
  State<TomarAsistenciaPage> createState() => _TomarAsistenciaPageState();
}

class _TomarAsistenciaPageState extends State<TomarAsistenciaPage> {
  final _horariosService = HorariosService();
  final _asistenciasService = AsistenciasService();
  List<dynamic> _alumnos = [];
  Map<int, String> _asistencias = {};
  bool _isLoading = true;
  bool _isSaving = false;
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAlumnos();
  }

  Future<void> _loadAlumnos() async {
    try {
      setState(() => _isLoading = true);
      final response = await _horariosService.getAlumnosByHorario(widget.horarioId);
      setState(() {
        _alumnos = response['data'] ?? [];
        // Inicializar todos como presentes
        for (var alumno in _alumnos) {
          _asistencias[alumno['id']] = 'PRESENTE';
        }
      });
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, e, errorContext: 'load_data');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _guardarAsistencias() async {
    try {
      setState(() => _isSaving = true);

      final asistenciasData = _asistencias.entries.map((e) => {
        'alumnoId': e.key,
        'estado': e.value,
      }).toList();

      await _asistenciasService.createMultiple(
        horarioId: widget.horarioId,
        fecha: _fechaSeleccionada.toIso8601String().split('T')[0],
        asistencias: asistenciasData,
      );

      if (mounted) {
        MessageHelper.showSuccess(context, 'Asistencias guardadas correctamente');
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, e, errorContext: 'asistencias');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _cambiarEstado(int alumnoId) {
    setState(() {
      final estadoActual = _asistencias[alumnoId];
      switch (estadoActual) {
        case 'PRESENTE':
          _asistencias[alumnoId] = 'TARDANZA';
          break;
        case 'TARDANZA':
          _asistencias[alumnoId] = 'FALTA';
          break;
        case 'FALTA':
          _asistencias[alumnoId] = 'JUSTIFICADA';
          break;
        case 'JUSTIFICADA':
          _asistencias[alumnoId] = 'PRESENTE';
          break;
      }
    });
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'PRESENTE':
      case 'P':
        return AppTheme.successGreen;
      case 'FALTA':
      case 'F':
        return AppTheme.errorRed;
      case 'JUSTIFICADA':
      case 'J':
        return AppTheme.gray500;
      case 'TARDANZA':
      case 'T':
        return AppTheme.warningYellow;
      default:
        return AppTheme.gray500;
    }
  }

  Widget _buildMobileAlumnoItem(
    BuildContext context,
    dynamic alumno,
    String estado,
    int index,
  ) {
    return InkWell(
      onTap: () => _cambiarEstado(alumno['id']),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _getEstadoColor(estado),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${alumno['usuario']['apellidos']}, ${alumno['usuario']['nombres']}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    'DNI: ${alumno['usuario']['dni']} - ${alumno['codigo']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            StatusBadge(
              estado: estado,
              size: StatusBadgeSize.medium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopAlumnoItem(
    BuildContext context,
    dynamic alumno,
    String estado,
    int index,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getEstadoColor(estado),
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        '${alumno['usuario']['apellidos']}, ${alumno['usuario']['nombres']}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'DNI: ${alumno['usuario']['dni']} - ${alumno['codigo']}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: GestureDetector(
        onTap: () => _cambiarEstado(alumno['id']),
        child: StatusBadge(
          estado: estado,
          size: StatusBadgeSize.large,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Responsive.isMobile(context)
            ? Text(widget.nombreCurso)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.nombreCurso),
                  Text(
                    widget.nombreSeccion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray500,
                        ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final fecha = await showDatePicker(
                context: context,
                initialDate: _fechaSeleccionada,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
              );
              if (fecha != null) {
                setState(() => _fechaSeleccionada = fecha);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            color: AppTheme.gray100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha: ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    StatusBadge(estado: 'P', size: StatusBadgeSize.small),
                    const SizedBox(width: AppTheme.spacingXS),
                    StatusBadge(estado: 'T', size: StatusBadgeSize.small),
                    const SizedBox(width: AppTheme.spacingXS),
                    StatusBadge(estado: 'F', size: StatusBadgeSize.small),
                    const SizedBox(width: AppTheme.spacingXS),
                    StatusBadge(estado: 'J', size: StatusBadgeSize.small),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _alumnos.isEmpty
                    ? const EmptyState(
                        icon: Icons.people_outline,
                        title: 'No hay alumnos en esta sección',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingSM,
                        ),
                        itemCount: _alumnos.length,
                        itemBuilder: (context, index) {
                          final alumno = _alumnos[index];
                          final estado = _asistencias[alumno['id']] ?? 'PRESENTE';
                          final isMobile = Responsive.isMobile(context);
                          return CustomCard(
                            margin: EdgeInsets.symmetric(
                              horizontal: isMobile ? AppTheme.spacingSM : AppTheme.spacingMD,
                              vertical: AppTheme.spacingXS,
                            ),
                            child: isMobile
                                ? _buildMobileAlumnoItem(context, alumno, estado, index)
                                : _buildDesktopAlumnoItem(context, alumno, estado, index),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: CustomButton(
            text: 'Guardar Asistencias',
            onPressed: _guardarAsistencias,
            isLoading: _isSaving,
          ),
        ),
      ),
    );
  }

}
