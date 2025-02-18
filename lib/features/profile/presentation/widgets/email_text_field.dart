part of '../views/profile_view.dart';

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
    required this.email,
  });
  final String? email;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      readOnly: true,
      controller: TextEditingController(text: email ?? ''),
      label: LocaleKeys.auth_fields_email.tr(),
    );
  }
}
