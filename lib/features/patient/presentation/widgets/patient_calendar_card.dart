import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../domain/entities/patient_program_day.dart';


class PatientCalendarCard extends StatelessWidget {
  final DateTime monthDate;
  final List<PatientProgramDay> days;
  final DateTime selectedDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final ValueChanged<DateTime> onDayTap;

  const PatientCalendarCard({
    super.key,
    required this.monthDate,
    required this.days,
    required this.selectedDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sortedDays = [...days]..sort((a, b) => a.date.compareTo(b.date));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatMonth(monthDate),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
              _ArrowButton(
                icon: Icons.chevron_left,
                onTap: onPreviousWeek,
              ),
              const SizedBox(width: 8),
              _ArrowButton(
                icon: Icons.chevron_right,
                onTap: onNextWeek,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              _WeekdayLabel('Пн'),
              _WeekdayLabel('Вт'),
              _WeekdayLabel('Ср'),
              _WeekdayLabel('Чт'),
              _WeekdayLabel('Пт'),
              _WeekdayLabel('Сб'),
              _WeekdayLabel('Вс'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(7, (index) {
              final day = index < sortedDays.length ? sortedDays[index] : null;
              final date = day?.date ??
                  monthDate.add(
                    Duration(days: index),
                  );

              return Expanded(
                child: _CalendarDayButton(
                  date: date,
                  selected: _isSameDate(date, selectedDate),
                  hasTraining: day?.hasTraining ?? false,
                  completed: day?.isCompleted ?? false,
                  onTap: () => onDayTap(date),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatMonth(DateTime date) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;

  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

class _CalendarDayButton extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final bool hasTraining;
  final bool completed;
  final VoidCallback onTap;

  const _CalendarDayButton({
    required this.date,
    required this.selected,
    required this.hasTraining,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    final outlined = hasTraining && !selected;
    final filled = selected;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? primary : Colors.transparent,
            shape: BoxShape.circle,
            border: outlined
                ? Border.all(
              color: primary,
              width: 1,
            )
                : null,
          ),
          child: Text(
            date.day.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: filled ? Colors.white : colors.textPrimary,
              fontWeight: selected || completed
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({
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
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: colors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}