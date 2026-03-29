class DoctorPatient {
  final String assignmentId;
  final String patientId;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String email;
  final String phoneNumber;
  final bool isActive;

  const DoctorPatient({
    required this.assignmentId,
    required this.patientId,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.isActive,
  });

  String get fullName {
    final p = patronymic.trim();
    return p.isEmpty ? '$lastName $firstName' : '$lastName $firstName $p';
  }
}