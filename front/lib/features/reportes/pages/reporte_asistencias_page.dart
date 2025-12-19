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

class _ReporteAsistenciasPageState extends State<ReporteAsistenciasPage>
    with SingleTickerProviderStateMixin {
  final _reportesService = ReportesService();
  Map<String, dynamic>? _reporte;
  bool _isLoading = true;
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fechaFin = DateTime.now();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _loadReporte();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      _animationController.forward();
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
      _animationController.reverse().then((_) {
        setState(() {
          if (isInicio) {
            _fechaInicio = fecha;
          } else {
            _fechaFin = fecha;
          }
        });
        _loadReporte();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      appBar: isDesktop ? null : AppBar(
        title: Text(widget.titulo),
      ),
      body: Column(
        children: [
          // Selector de fechas
          _buildDateFilter(isDesktop),
          // Contenido del reporte
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _reporte == null
                    ? const Center(child: Text('No hay datos disponibles'))
                    : RefreshIndicator(
                        onRefresh: _loadReporte,
                        child: _buildReporteContent(isDesktop),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(
        isDesktop ? AppTheme.spacingLG : AppTheme.spacingMD,
      ),
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        border: Border(
          bottom: BorderSide(color: AppTheme.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFechaButton('Desde', _fechaInicio, () => _selectFecha(true)),
          ),
          const SizedBox(width: AppTheme.spacingMD),
          Expanded(
            child: _buildFechaButton('Hasta', _fechaFin, () => _selectFecha(false)),
          ),
          if (isDesktop) ...[
            const SizedBox(width: AppTheme.spacingMD),
            ElevatedButton.icon(
              onPressed: _loadReporte,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReporteContent(bool isDesktop) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(
        isDesktop ? AppTheme.spacingLG : AppTheme.spacingMD,
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: isDesktop
            ? _buildDesktopLayout()
            : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumen y estadísticas en fila
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gráfico circular
              Expanded(
                flex: 2,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildResumenCard(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingLG),
              // Estadísticas detalladas
              Expanded(
                flex: 3,
                child: _buildEstadisticasCard(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingLG),
        // Lista de asistencias
        _buildListaAsistencias(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: _buildResumenCard(),
        ),
        const SizedBox(height: AppTheme.spacingMD),
        _buildEstadisticasGrid(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildListaAsistencias(),
      ],
    );
  }

  Widget _buildFechaButton(String label, DateTime fecha, VoidCallback onTap) {
    return _HoverCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
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
                  const SizedBox(height: 2),
                  Text(
                    '${fecha.day}/${fecha.month}/${fecha.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, size: 16, color: AppTheme.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenCard() {
    final total = _reporte?['total'] ?? 0;
    final presentes = _reporte?['presentes'] ?? 0;
    final porcentaje = total > 0 ? (presentes / total * 100) : 0.0;
    
    Color getColorByPercentage() {
      if (porcentaje >= 80) return AppTheme.successGreen;
      if (porcentaje >= 60) return AppTheme.warningYellow;
      return AppTheme.errorRed;
    }

    return _CardContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Porcentaje de Asistencia',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingLG),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: porcentaje / 100,
                  strokeWidth: 16,
                  backgroundColor: AppTheme.gray200,
                  color: getColorByPercentage(),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${porcentaje.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: getColorByPercentage(),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$presentes de $total',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMD,
              vertical: AppTheme.spacingSM,
            ),
            decoration: BoxDecoration(
              color: getColorByPercentage().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
            child: Text(
              _getPercentageMessage(porcentaje),
              style: TextStyle(
                color: getColorByPercentage(),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPercentageMessage(double porcentaje) {
    if (porcentaje >= 90) return '¡Excelente asistencia!';
    if (porcentaje >= 80) return 'Buena asistencia';
    if (porcentaje >= 60) return 'Asistencia regular';
    return 'Necesita mejorar';
  }

  Widget _buildEstadisticasCard() {
    final presentes = _reporte?['presentes'] ?? 0;
    final tardanzas = _reporte?['tardanzas'] ?? 0;
    final faltas = _reporte?['faltas'] ?? 0;
    final justificadas = _reporte?['justificadas'] ?? 0;
    final total = _reporte?['total'] ?? 0;

    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estadísticas Detalladas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingLG),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _buildStatRow(
                    'Presentes',
                    presentes,
                    total,
                    AppTheme.successGreen,
                    Icons.check_circle,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: _buildStatRow(
                    'Tardanzas',
                    tardanzas,
                    total,
                    AppTheme.warningYellow,
                    Icons.access_time,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: _buildStatRow(
                    'Faltas',
                    faltas,
                    total,
                    AppTheme.errorRed,
                    Icons.cancel,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: _buildStatRow(
                    'Justificadas',
                    justificadas,
                    total,
                    AppTheme.gray500,
                    Icons.description,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, int total, Color color, IconData icon) {
    final percentage = total > 0 ? (value / total * 100) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppTheme.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '$value (${percentage.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: AppTheme.gray200,
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticasGrid() {
    final presentes = _reporte?['presentes'] ?? 0;
    final tardanzas = _reporte?['tardanzas'] ?? 0;
    final faltas = _reporte?['faltas'] ?? 0;
    final justificadas = _reporte?['justificadas'] ?? 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildEstadisticaItem('Presentes', presentes, AppTheme.successGreen, Icons.check_circle),
            ),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(
              child: _buildEstadisticaItem('Tardanzas', tardanzas, AppTheme.warningYellow, Icons.access_time),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSM),
        Row(
          children: [
            Expanded(
              child: _buildEstadisticaItem('Faltas', faltas, AppTheme.errorRed, Icons.cancel),
            ),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(
              child: _buildEstadisticaItem('Just.', justificadas, AppTheme.gray500, Icons.description),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEstadisticaItem(String label, int valor, Color color, IconData icon) {
    return _CardContainer(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            '$valor',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
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
        Row(
          children: [
            Text(
              'Historial de Asistencias',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              '${asistencias.length} registros',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMD),
        ...asistencias.take(20).map((asistencia) => _buildAsistenciaItem(asistencia)),
        if (asistencias.length > 20)
          Padding(
            padding: const EdgeInsets.only(top: AppTheme.spacingMD),
            child: Center(
              child: Text(
                'Mostrando 20 de ${asistencias.length} registros',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: AppTheme.gray500),
                    const SizedBox(width: 4),
                    Text(
                      fecha,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
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

// Contenedor de tarjeta reutilizable
class _CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _CardContainer({
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Card con hover effect
class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverCard({
    required this.child,
    required this.onTap,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.gray100 : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(
            color: _isHovered 
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : AppTheme.gray300,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
