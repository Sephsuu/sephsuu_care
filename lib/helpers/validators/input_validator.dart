class InputValidator {
  InputValidator._();

  static String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? email(String? value) {
    final required = requiredText(value, 'Email');
    if (required != null) return required;

    final email = value!.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? phone(String? value, String label) {
    final required = requiredText(value, label);
    if (required != null) return required;

    final digits = value!.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 10) return 'Enter a valid $label';

    return null;
  }
}
