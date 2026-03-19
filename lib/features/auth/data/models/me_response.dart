class MeResponse {
  final String userId;
  final String clinicId;
  final String email;
  final String role;
  final String firstName;
  final String lastName;

  const MeResponse({
    required this.userId,
    required this.clinicId,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      userId: json['userId'] as String,
      clinicId: json['clinicId'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      firstName: (json['firstName'] ?? '') as String,
      lastName: (json['lastName'] ?? '') as String,
    );
  }
}