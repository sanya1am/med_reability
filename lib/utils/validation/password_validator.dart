class PasswordValidationResult {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasDigit;
  final bool hasSpecialChar;

  const PasswordValidationResult({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasDigit,
    required this.hasSpecialChar,
  });

  bool get isValid {
    return hasMinLength && hasUppercase && hasDigit && hasSpecialChar;
  }

  List<String> get missingRequirements {
    final items = <String>[];

    if (!hasMinLength) {
      items.add('не менее 8 символов');
    }

    if (!hasUppercase) {
      items.add('одна заглавная буква');
    }

    if (!hasDigit) {
      items.add('одна цифра');
    }

    if (!hasSpecialChar) {
      items.add('один спецсимвол');
    }

    return items;
  }

  String get errorText {
    return 'Пароль должен содержать: ${missingRequirements.join(', ')}.';
  }
}

class PasswordValidator {
  static final _uppercaseRegex = RegExp(r'[A-ZА-Я]');
  static final _digitRegex = RegExp(r'\d');
  static final _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`;\[\]\\/]');

  static PasswordValidationResult validate(String password) {
    return PasswordValidationResult(
      hasMinLength: password.length >= 8,
      hasUppercase: _uppercaseRegex.hasMatch(password),
      hasDigit: _digitRegex.hasMatch(password),
      hasSpecialChar: _specialCharRegex.hasMatch(password),
    );
  }
}