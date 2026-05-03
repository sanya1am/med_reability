class ChangeMyPasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangeMyPasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}