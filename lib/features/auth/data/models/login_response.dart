class LoginResponse {
  final String accessToken;
  final DateTime expiresAtUtc;

  const LoginResponse({required this.accessToken, required this.expiresAtUtc});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
    );
  }
}