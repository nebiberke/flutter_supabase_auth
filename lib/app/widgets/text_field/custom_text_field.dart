import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/padding_constants.dart';

/// A custom text field widget that extends [TextFormField] and provides a more convenient way to create text fields.
///
/// Example usage:
/// ```dart
/// CustomTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   obscureText: false,
///   readOnly: false,
///   controller: TextEditingController(),
///   validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
///   keyboardType: TextInputType.emailAddress,
///   onChanged: (value) => print(value),
/// );
/// ```
final class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    super.key,
    this.hint,
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.textInputAction,
  });
  final String label;
  final String? hint;
  final bool obscureText;
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.verticalLow(),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged,
        readOnly: readOnly,
        textInputAction: textInputAction ?? TextInputAction.done,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          errorMaxLines: 2,
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}
