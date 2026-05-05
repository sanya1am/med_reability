import 'package:flutter/material.dart';
import 'package:med_reability/features/doctor/domain/entities/doctor_patient_overview_workout_exercise.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_today_workout_card.dart';


class PatientTodayWorkoutList extends StatelessWidget {
  final List<DoctorPatientOverviewWorkoutExercise> exercises;

  const PatientTodayWorkoutList({
    super.key,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...exercises]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: sorted.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PatientTodayWorkoutCard(
            item: item,
          ),
        );
      }).toList(),
    );
  }
}