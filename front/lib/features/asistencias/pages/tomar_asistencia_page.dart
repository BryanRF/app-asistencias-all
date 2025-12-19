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

class _TomarAsistenciaPageState extends State<TomarAsistenciaPage> 
    with SingleTickerProviderStateMixin {
  final _horariosService = HorariosService();
  final _asistenciasService = AsistenciasService();
  List<dynamic> _alumnos = [];
  Map<int, String> _asistencias = {};
  bool _isLoading = true;
  bool _isSaving = false;
  DateTime _fechaSeleccionada = DateTime.now();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _loadAlumnos();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      _animationController.forward();
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

  void _setEstadoTodos(String estado) {
    setState(() {
      for (var alumno in _alumnos) {
        _asistencias[alumno['id']] = estado;
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

  Map<String, int> _getEstadisticas() {
    final stats = <String, int>{
      'PRESENTE': 0,
      'TARDANZA': 0,
      'FALTA': 0,
      'JUSTIFICADA': 0,
    };
    
    for (var estado in _asistencias.values) {
      stats[estado] = (stats[estado] ?? 0) + 1;
    }
    
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      appBar: _buildAppBar(isDesktop),
      body: Column(
        children: [
          // Header con fecha y estadísticas
          _buildHeader(isDesktop || isTablet),
          // Lista de alumnos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _alumnos.isEmpty
                    ? const EmptyState(
                        icon: Icons.people_outline,
                        title: 'No hay alumnos en esta sección',
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: isDesktop
                            ? _buildDesktopGrid()
                            : _buildMobileList(),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDesktop) {
    return AppBar(
      title: isDesktop
          ? Row(
              children: [
                Text(widget.nombreCurso),
                const SizedBox(width: AppTheme.spacingSM),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSM,
                    vertical: AppTheme.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.gray100,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Text(
                    widget.nombreSeccion,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            )
          : Text(widget.nombreCurso),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today),
          tooltip: 'Cambiar fecha',
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
        if (!Responsive.isMobile(context)) ...[
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Más opciones',
            onSelected: (value) {
              _setEstadoTodos(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'PRESENTE',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.successGreen),
                    SizedBox(width: 8),
                    Text('Marcar todos presentes'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'FALTA',
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: AppTheme.errorRed),
                    SizedBox(width: 8),
                    Text('Marcar todos ausentes'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(bool showStats) {
    final stats = _getEstadisticas();
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        border: Border(
          bottom: BorderSide(color: AppTheme.gray200, width: 1),
        ),
      ),
      child: showStats
          ? Row(
              children: [
                // Fecha
                Expanded(
                  child: _buildDateSelector(),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                // Estadísticas
                _buildStatChip('P', stats['PRESENTE'] ?? 0, AppTheme.successGreen),
                const SizedBox(width: AppTheme.spacingSM),
                _buildStatChip('T', stats['TARDANZA'] ?? 0, AppTheme.warningYellow),
                const SizedBox(width: AppTheme.spacingSM),
                _buildStatChip('F', stats['FALTA'] ?? 0, AppTheme.errorRed),
                const SizedBox(width: AppTheme.spacingSM),
                _buildStatChip('J', stats['JUSTIFICADA'] ?? 0, AppTheme.gray500),
              ],
            )
          : Column(
              children: [
                _buildDateSelector(),
                const SizedBox(height: AppTheme.spacingSM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () async {
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
      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingSM,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.gray300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today, size: 16, color: AppTheme.gray600),
            const SizedBox(width: AppTheme.spacingSM),
            Text(
              'Fecha: ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMD,
        vertical: AppTheme.spacingSM,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSM),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      child: Wrap(
        spacing: AppTheme.spacingMD,
        runSpacing: AppTheme.spacingMD,
        children: _alumnos.asMap().entries.map((entry) {
          final index = entry.key;
          final alumno = entry.value;
          final estado = _asistencias[alumno['id']] ?? 'PRESENTE';
          return SizedBox(
            width: 300,
            child: _buildDesktopAlumnoCard(alumno, estado, index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopAlumnoCard(dynamic alumno, String estado, int index) {
    final color = _getEstadoColor(estado);
    
    return _HoverCard(
      onTap: () => _cambiarEstado(alumno['id']),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: color,
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
                        '${alumno['usuario']['apellidos']}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${alumno['usuario']['nombres']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Row(
              children: [
                Icon(Icons.badge_outlined, size: 14, color: AppTheme.gray500),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  'DNI: ${alumno['usuario']['dni']}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                StatusBadge(
                  estado: estado,
                  size: StatusBadgeSize.medium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: AppTheme.spacingSM,
      ),
      itemCount: _alumnos.length,
      itemBuilder: (context, index) {
        final alumno = _alumnos[index];
        final estado = _asistencias[alumno['id']] ?? 'PRESENTE';
        return CustomCard(
          margin: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingSM,
            vertical: AppTheme.spacingXS,
          ),
          child: _buildMobileAlumnoItem(context, alumno, estado, index),
        );
      },
    );
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

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: AppTheme.gray200, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (!Responsive.isMobile(context)) ...[
              Text(
                '${_alumnos.length} alumnos',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
            ],
            Expanded(
              child: CustomButton(
                text: 'Guardar Asistencias',
                onPressed: _guardarAsistencias,
                isLoading: _isSaving,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget con efecto hover para cards
class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? color;

  const _HoverCard({
    required this.child,
    required this.onTap,
    this.color,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.color ?? Theme.of(context).colorScheme.primary;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered
              ? borderColor.withValues(alpha: 0.05)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: _isHovered 
                ? borderColor.withValues(alpha: 0.5)
                : AppTheme.gray200,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? borderColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 15 : 8,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
          ],
        ),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -2))
            : Matrix4.identity(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
