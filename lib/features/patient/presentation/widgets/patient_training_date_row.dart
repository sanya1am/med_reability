import 'package:flutter/material.dart';

class PatientTrainingDateRow extends StatelessWidget {
  final DateTime date;
  final int? exercisesCount;

  const PatientTrainingDateRow({
    super.key,
    required this.date,
    required this.exercisesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _formatDate(date),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        if (exercisesCount != null)
          Text(
            _formatExercisesCount(exercisesCount!),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = [
      'понедельник',
      'вторник',
      'среда',
      'четверг',
      'пятница',
      'суббота',
      'воскресенье',
    ];

    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '${_capitalize(weekday)}, ${date.day} $month';
  }

  String _formatExercisesCount(int count) {
    final mod10 = count % 10;
    final mod100 = count % 100;

    if (mod10 == 1 && mod100 != 11) return '$count упражнение';

    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return '$count упражнения';
    }

    return '$count упражнений';
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}