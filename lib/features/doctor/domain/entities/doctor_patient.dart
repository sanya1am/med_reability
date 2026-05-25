class DoctorPatient {
  final String assignmentId;
  final String patientId;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final bool isActive;
  final bool hasPlan;

  const DoctorPatient({
    required this.assignmentId,
    required this.patientId,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.isActive,
    required this.hasPlan,
  });

  String get fullFullName {
    final p = patronymic.trim();
    return p.isEmpty ? '$lastName $firstName' : '$lastName $firstName $p';
  }
  String get fullName {
    return '$lastName $firstName';
  }
}