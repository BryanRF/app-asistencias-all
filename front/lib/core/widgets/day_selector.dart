import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Selector de días de la semana reutilizable
class DaySelector extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final List<String> days;
  final int? maxDays;

  const DaySelector({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    this.days = const ['', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'],
    this.maxDays,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final maxItems = maxDays ?? (days.length - 1);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
        itemCount: maxItems,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = selectedDay == day;
          return GestureDetector(
            onTap: () => onDaySelected(day),
            child: Container(
              margin: const EdgeInsets.only(right: AppTheme.spacingSM),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLG,
                vertical: AppTheme.spacingSM,
              ),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : AppTheme.gray100,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: Center(
                child: Text(
                  days[day],
                  style: TextStyle(
                    color: isSelected ? onPrimaryColor : primaryColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
