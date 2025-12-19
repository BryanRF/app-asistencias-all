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

class _HorariosPageState extends State<HorariosPage> with SingleTickerProviderStateMixin {
  final _horariosService = HorariosService();
  List<dynamic> _horarios = [];
  bool _isLoading = true;
  int _selectedDia = DateTime.now().weekday;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadHorarios();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadHorarios() async {
    try {
      setState(() => _isLoading = true);
      final response = await _horariosService.findByProfesor(widget.profesorId);
      setState(() {
        _horarios = response['data'] ?? [];
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

  List<dynamic> _getHorariosDia(int dia) {
    return _horarios
        .where((h) => h['diaSemana'] == dia)
        .toList()
      ..sort((a, b) => (a['horaInicio'] as String).compareTo(b['horaInicio'] as String));
  }

  void _onDayChanged(int day) {
    if (day == _selectedDia) return;
    
    _animationController.reverse().then((_) {
      setState(() => _selectedDia = day);
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      appBar: isDesktop ? null : AppBar(
        title: const Text('Mis Horarios'),
      ),
      body: Column(
        children: [
          // Header con selector de días
          _buildDayHeader(isDesktop),
          const Divider(height: 1),
          // Lista de horarios
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadHorarios,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildHorariosList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(bool isDesktop) {
    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Row(
          children: [
            for (int i = 1; i <= 5; i++) ...[
              if (i > 1) const SizedBox(width: AppTheme.spacingSM),
              Expanded(
                child: _buildDayChip(i),
              ),
            ],
          ],
        ),
      );
    }

    return DaySelector(
      selectedDay: _selectedDia,
      onDaySelected: _onDayChanged,
      days: _diasSemana,
      maxDays: 5,
    );
  }

  Widget _buildDayChip(int day) {
    final isSelected = _selectedDia == day;
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => _onDayChanged(day),
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingMD,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : AppTheme.gray100,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary 
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              _diasSemana[day].substring(0, 3),
              style: TextStyle(
                color: isSelected 
                    ? theme.colorScheme.onPrimary 
                    : AppTheme.gray600,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_getHorariosDia(day).length}',
              style: TextStyle(
                color: isSelected 
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.8)
                    : AppTheme.gray500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorariosList() {
    final horariosDia = _getHorariosDia(_selectedDia);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (horariosDia.isEmpty) {
      return EmptyState(
        icon: Icons.calendar_today_outlined,
        title: 'No hay clases el ${_diasSemana[_selectedDia]}',
      );
    }

    if (isDesktop) {
      return _buildDesktopGrid(horariosDia);
    } else if (isTablet) {
      return _buildTabletGrid(horariosDia);
    } else {
      return _buildMobileList(horariosDia);
    }
  }

  Widget _buildDesktopGrid(List<dynamic> horarios) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      child: Wrap(
        spacing: AppTheme.spacingMD,
        runSpacing: AppTheme.spacingMD,
        children: horarios.map((horario) {
          return SizedBox(
            width: 360,
            child: _buildDesktopHorarioCard(horario),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabletGrid(List<dynamic> horarios) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacingMD,
        mainAxisSpacing: AppTheme.spacingMD,
        childAspectRatio: 1.5,
      ),
      itemCount: horarios.length,
      itemBuilder: (context, index) {
        return _buildDesktopHorarioCard(horarios[index]);
      },
    );
  }

  Widget _buildMobileList(List<dynamic> horarios) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingSM),
      itemCount: horarios.length,
      itemBuilder: (context, index) {
        final horario = horarios[index];
        return CustomCard(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingSM),
          child: _buildMobileHorarioItem(context, horario),
        );
      },
    );
  }

  Widget _buildDesktopHorarioCard(dynamic horario) {
    return _HoverCard(
      onTap: () => _navigateToAsistencia(horario),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusMD),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSM,
                    vertical: AppTheme.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Text(
                    '${_formatTime(horario['horaInicio'])} - ${_formatTime(horario['horaFin'])}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  horario['curso']?['nombre'] ?? 'Sin curso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingMD),
                _buildInfoChip(
                  Icons.class_,
                  '${horario['seccion']?['grado']?['nombre'] ?? ''} - ${horario['seccion']?['nombre'] ?? ''}',
                ),
                const SizedBox(height: AppTheme.spacingSM),
                _buildInfoChip(
                  Icons.schedule,
                  horario['turno']?['nombre'] ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.gray500,
        ),
        const SizedBox(width: AppTheme.spacingSM),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
              onPressed: () => _navigateToAsistencia(horario),
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

  void _navigateToAsistencia(dynamic horario) {
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
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    // Asume formato HH:MM:SS, retorna HH:MM
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }
}

// Widget con efecto hover para cards
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
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: _isHovered 
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                : AppTheme.gray200,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
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
