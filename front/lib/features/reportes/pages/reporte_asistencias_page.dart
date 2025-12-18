import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/reportes_service.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/widgets.dart';

class ReporteAsistenciasPage extends StatefulWidget {
  final int? alumnoId;
  final int? seccionId;
  final String titulo;

  const ReporteAsistenciasPage({
    super.key,
    this.alumnoId,
    this.seccionId,
    required this.titulo,
  });

  @override
  State<ReporteAsistenciasPage> createState() => _ReporteAsistenciasPageState();
}

class _ReporteAsistenciasPageState extends State<ReporteAsistenciasPage> {
  final _reportesService = ReportesService();
  Map<String, dynamic>? _reporte;
  bool _isLoading = true;
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fechaFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadReporte();
  }

  Future<void> _loadReporte() async {
    try {
      setState(() => _isLoading = true);
      
      final fechaInicio = _fechaInicio.toIso8601String().split('T')[0];
      final fechaFin = _fechaFin.toIso8601String().split('T')[0];
      
      Map<String, dynamic> response;
      if (widget.alumnoId != null) {
        response = await _reportesService.reportePorAlumno(
          widget.alumnoId!,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );
      } else if (widget.seccionId != null) {
        response = await _reportesService.reportePorSeccion(
          widget.seccionId!,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );
      } else {
        throw Exception('Debe proporcionar alumnoId o seccionId');
      }
      
      setState(() {
        _reporte = response;
      });
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, e, errorContext: 'load_data');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectFecha(bool isInicio) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: isInicio ? _fechaInicio : _fechaFin,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    
    if (fecha != null) {
      setState(() {
        if (isInicio) {
          _fechaInicio = fecha;
        } else {
          _fechaFin = fecha;
        }
      });
      _loadReporte();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: Column(
        children: [
          // Selector de fechas
          Container(
            padding: EdgeInsets.all(
              Responsive.isMobile(context) ? AppTheme.spacingSM : AppTheme.spacingMD,
            ),
            color: AppTheme.gray100,
            child: Responsive.isMobile(context)
                ? Column(
                    children: [
                      _buildFechaButton('Desde', _fechaInicio, () => _selectFecha(true)),
                      const SizedBox(height: AppTheme.spacingSM),
                      _buildFechaButton('Hasta', _fechaFin, () => _selectFecha(false)),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildFechaButton('Desde', _fechaInicio, () => _selectFecha(true)),
                      ),
                      const SizedBox(width: AppTheme.spacingMD),
                      Expanded(
                        child: _buildFechaButton('Hasta', _fechaFin, () => _selectFecha(false)),
                      ),
                    ],
                  ),
          ),
          // Contenido del reporte
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _reporte == null
                    ? const Center(child: Text('No hay datos disponibles'))
                    : RefreshIndicator(
                        onRefresh: _loadReporte,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(AppTheme.spacingMD),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildResumenCard(),
                              const SizedBox(height: AppTheme.spacingMD),
                              _buildEstadisticasGrid(),
                              const SizedBox(height: AppTheme.spacingMD),
                              _buildListaAsistencias(),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFechaButton(String label, DateTime fecha, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.gray300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: AppTheme.gray500),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${fecha.day}/${fecha.month}/${fecha.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenCard() {
    final total = _reporte?['total'] ?? 0;
    final presentes = _reporte?['presentes'] ?? 0;
    final porcentaje = total > 0 ? (presentes / total * 100) : 0.0;

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLG),
        child: Column(
          children: [
            Text(
              'Porcentaje de Asistencia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: porcentaje / 100,
                    strokeWidth: 12,
                    backgroundColor: AppTheme.gray200,
                    color: porcentaje >= 70
                        ? AppTheme.successGreen
                        : porcentaje >= 50
                            ? AppTheme.warningYellow
                            : AppTheme.errorRed,
                  ),
                ),
                Text(
                  '${porcentaje.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Text(
              '$presentes de $total clases',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadisticasGrid() {
    final presentes = _reporte?['presentes'] ?? 0;
    final tardanzas = _reporte?['tardanzas'] ?? 0;
    final faltas = _reporte?['faltas'] ?? 0;
    final justificadas = _reporte?['justificadas'] ?? 0;
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildEstadisticaItem('Presentes', presentes, AppTheme.successGreen),
              ),
              const SizedBox(width: AppTheme.spacingSM),
              Expanded(
                child: _buildEstadisticaItem('Tardanzas', tardanzas, AppTheme.warningYellow),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Row(
            children: [
              Expanded(
                child: _buildEstadisticaItem('Faltas', faltas, AppTheme.errorRed),
              ),
              const SizedBox(width: AppTheme.spacingSM),
              Expanded(
                child: _buildEstadisticaItem('Just.', justificadas, AppTheme.gray500),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildEstadisticaItem('Presentes', presentes, AppTheme.successGreen),
        ),
        const SizedBox(width: AppTheme.spacingSM),
        Expanded(
          child: _buildEstadisticaItem('Tardanzas', tardanzas, AppTheme.warningYellow),
        ),
        const SizedBox(width: AppTheme.spacingSM),
        Expanded(
          child: _buildEstadisticaItem('Faltas', faltas, AppTheme.errorRed),
        ),
        const SizedBox(width: AppTheme.spacingSM),
        Expanded(
          child: _buildEstadisticaItem('Just.', justificadas, AppTheme.gray500),
        ),
      ],
    );
  }

  Widget _buildEstadisticaItem(String label, int valor, Color color) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Center(
                child: Text(
                  '$valor',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSM),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaAsistencias() {
    final asistencias = _reporte?['asistencias'] as List<dynamic>? ?? [];

    if (asistencias.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historial de Asistencias',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        ...asistencias.take(20).map((asistencia) => _buildAsistenciaItem(asistencia)),
      ],
    );
  }

  Widget _buildAsistenciaItem(dynamic asistencia) {
    final estado = asistencia['estado'] as String? ?? '';
    final fecha = asistencia['fecha'] as String? ?? '';
    final curso = asistencia['horario']?['curso']?['nombre'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSM),
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  curso,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  fecha,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          StatusBadge(
            estado: estado,
            size: StatusBadgeSize.small,
          ),
        ],
      ),
    );
  }
}
