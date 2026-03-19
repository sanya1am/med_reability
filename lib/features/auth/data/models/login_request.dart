class LoginRequest {
  final String clinicId;
  final String email;
  final String password;

  const LoginRequest({
    required this.clinicId,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'clinicId': clinicId,
    'email': email,
    'password': password,
  };
}