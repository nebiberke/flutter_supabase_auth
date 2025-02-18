part of '../views/profile_view.dart';

class _FullNameTextField extends StatelessWidget {
  const _FullNameTextField({
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      label: LocaleKeys.auth_fields_full_name.tr(),
      keyboardType: TextInputType.name,
    );
  }
}
