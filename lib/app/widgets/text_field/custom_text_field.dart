import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

class CustomTextField extends StatelessWidget {
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
  });
  final String label;
  final String? hint;
  final bool obscureText;
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingBottomLow,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged,
        readOnly: readOnly,
        textInputAction: TextInputAction.done,
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
