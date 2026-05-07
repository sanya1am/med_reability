import 'package:flutter/material.dart';
import 'package:med_reability/features/doctor/domain/entities/doctor_patient_overview_patient.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class DoctorPatientOverviewHeader extends StatelessWidget {
  final DoctorPatientOverviewPatient patient;

  const DoctorPatientOverviewHeader({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PatientAvatar(
          imageUrl: patient.imageUrl,
        ),
        const SizedBox(height: 12),
        Text(
          patient.fullName.isEmpty ? 'Пациент' : patient.fullName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium
        ),
      ],
    );
  }
}

class _PatientAvatar extends StatelessWidget {
  final String? imageUrl;

  const _PatientAvatar({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final url = imageUrl;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url.isEmpty
          ? Icon(
        Icons.person,
        size: 52,
        color: colors.hint,
      )
          : Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Icon(
            Icons.person,
            size: 52,
            color: colors.hint,
          );
        },
      ),
    );
  }
}