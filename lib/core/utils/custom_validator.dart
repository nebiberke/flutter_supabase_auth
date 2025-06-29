import 'package:easy_localization/easy_localization.dart';

final class CustomValidator {
  CustomValidator._();
  static String? emailValidator(String? value) {
    // Check if email is empty
    if (value == null || value.isEmpty) {
      return 'auth.validation.email_required'.tr();
    }
    // Check if email is valid
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'auth.validation.email_invalid'.tr();
    }
    return null;
  }

  static String? dropdownValidator<T>(T? value) {
    if (value == null) {
      return 'auth.validation.dropdown_required'.tr();
    }
    return null;
  }

  static String? fullNameValidator(String? value) {
    // Check if full name is empty
    if (value == null || value.isEmpty) {
      return 'auth.validation.full_name_required'.tr();
    }

    // Check if first and last name are present
    if (!value.contains(' ')) {
      return 'auth.validation.full_name_format'.tr();
    }

    // Full name should only contain letters and spaces (including Turkish characters)
    final nameRegex = RegExp(r'^[a-zA-ZÇĞİÖŞÜçğıöşü\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'auth.validation.full_name_characters'.tr();
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    // Check if password is empty
    if (value == null || value.isEmpty) {
      return 'auth.validation.password_required'.tr();
    }

    // Minimum length check
    if (value.length < 8) {
      return 'auth.validation.password_min_length'.tr();
    }

    // Uppercase letter check
    if (!value.contains(RegExp('[A-Z]'))) {
      return 'auth.validation.password_uppercase'.tr();
    }

    // Lowercase letter check
    if (!value.contains(RegExp('[a-z]'))) {
      return 'auth.validation.password_lowercase'.tr();
    }

    // Number check
    if (!value.contains(RegExp('[0-9]'))) {
      return 'auth.validation.password_number'.tr();
    }

    // Special character check
    if (!value.contains(
      RegExp(r'''[!@#\$&₺€*~%^()+={}\[\]:;'"<>,.?\/\\|`_<>-]'''),
    )) {
      return 'auth.validation.password_special'.tr();
    }

    return null; // Password is valid if all rules are satisfied
  }

  static String? confirmPasswordValidator(String? value, String password) {
    // Check if confirm password is empty
    if (value == null || value.isEmpty) {
      return 'auth.validation.password_confirm_required'.tr();
    }
    // Check if confirm password matches password
    if (value.trim() != password.trim()) {
      return 'auth.validation.password_confirm_match'.tr();
    }
    return null;
  }
}
