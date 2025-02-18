part of '../views/profile_view.dart';

class _LanguageAndLogoutRow extends StatefulWidget {
  const _LanguageAndLogoutRow({
    required this.onLanguageSelected,
    required this.onLogout,
  });
  final VoidCallback onLanguageSelected;
  final VoidCallback onLogout;

  @override
  State<_LanguageAndLogoutRow> createState() => _LanguageAndLogoutRowState();
}

class _LanguageAndLogoutRowState extends State<_LanguageAndLogoutRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomOutlinedButton(
            text: LocaleKeys.language_title.tr(),
            textAlign: TextAlign.center,
            onPressed: widget.onLanguageSelected,
          ),
        ),
        context.horizontalSpacingLow,
        Expanded(
          child: CustomOutlinedButton(
            text: LocaleKeys.auth_actions_logout.tr(),
            onPressed: widget.onLogout,
          ),
        ),
      ],
    );
  }
}
