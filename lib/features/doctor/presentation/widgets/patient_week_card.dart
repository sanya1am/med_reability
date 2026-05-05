import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

import '../../domain/entities/doctor_patient_overview_day.dart';

class PatientWeekCard extends StatelessWidget {
  final int weekNumber;
  final List<DoctorPatientOverviewDay> days;
  final DateTime selectedDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final ValueChanged<DoctorPatientOverviewDay> onDayTap;

  const PatientWeekCard({
    super.key,
    required this.weekNumber,
    required this.days,
    required this.selectedDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Неделя $weekNumber',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _WeekArrowButton(
                icon: Icons.chevron_left,
                onTap: onPreviousWeek,
              ),
              const SizedBox(width: 8),
              _WeekArrowButton(
                icon: Icons.chevron_right,
                onTap: onNextWeek,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: _buildDayItems(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDayItems() {
    if (days.isEmpty) {
      return List.generate(7, (index) {
        final number = index + 1;

        return Expanded(
          child: _DayButton(
            label: number.toString(),
            selected: false,
            hasTraining: false,
            isCompleted: false,
            onTap: null,
          ),
        );
      });
    }

    return days.map((day) {
      final selected = _isSameDate(day.date, selectedDate);

      return Expanded(
        child: _DayButton(
          label: _resolveDayLabel(day),
          selected: selected,
          hasTraining: day.hasTraining,
          isCompleted: day.isCompleted,
          onTap: () => onDayTap(day),
        ),
      );
    }).toList();
  }

  String _resolveDayLabel(DoctorPatientOverviewDay day) {
    if (day.dayNumber > 0) {
      return day.dayNumber.toString();
    }

    return day.date.day.toString();
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _WeekArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _WeekArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: colors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

class _DayButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool hasTraining;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _DayButton({
    required this.label,
    required this.selected,
    required this.hasTraining,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    final shouldShowBorder = hasTraining && !selected;
    final shouldShowFilled = selected;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: shouldShowFilled ? primary : Colors.transparent,
            border: shouldShowBorder
                ? Border.all(
              color: primary,
              width: 1,
            )
                : null,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: shouldShowFilled ? Colors.white : colors.textPrimary,
              fontWeight:
              selected || isCompleted ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}