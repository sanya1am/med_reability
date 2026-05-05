class DoctorPatientOverviewPatient {
  final String id;
  final String clinicId;
  final String firstName;
  final String? patronymic;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final bool isActive;

  const DoctorPatientOverviewPatient({
    required this.id,
    required this.clinicId,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.isActive,
  });

  String get fullName {
    return [
      lastName,
      firstName,
      patronymic,
    ].whereType<String>().where((x) => x.trim().isNotEmpty).join(' ');
  }
}