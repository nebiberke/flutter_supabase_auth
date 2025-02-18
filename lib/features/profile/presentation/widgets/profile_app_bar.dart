part of '../views/profile_view.dart';

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar({
    required this.onThemeChanged,
    required this.isEditedNotifier,
    required this.onSave,
  });
  final void Function({required bool isLightTheme}) onThemeChanged;
  final ValueNotifier<bool> isEditedNotifier;
  final VoidCallback onSave;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  bool _isCurrentThemeLight(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>().state;

    return themeCubit.themeMode == ThemeMode.light ||
        (themeCubit.themeMode == ThemeMode.system &&
            context.mediaQuery.platformBrightness == Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        LocaleKeys.home_profile_title.tr(),
        style: context.textTheme.headlineSmall,
      ),
      // 56 is the default leading width
      leadingWidth: 56 + context.dynamicWidth(24),
      leading: Switch(
        thumbColor: WidgetStatePropertyAll(context.colorScheme.tertiary),
        trackOutlineColor: WidgetStatePropertyAll(context.colorScheme.outline),
        trackOutlineWidth: const WidgetStatePropertyAll(1),
        thumbIcon: WidgetStatePropertyAll(
          _isCurrentThemeLight(context)
              ? const Icon(Icons.sunny)
              : const Icon(Icons.nightlight_round),
        ),
        activeTrackColor: context.colorScheme.primary,
        inactiveTrackColor: context.colorScheme.primary,
        value: _isCurrentThemeLight(context),
        onChanged: (value) => onThemeChanged(isLightTheme: value),
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: isEditedNotifier,
          builder: (context, isEdited, _) {
            if (!isEdited) return const SizedBox.shrink();
            return Padding(
              padding: context.paddingHorizontalLow,
              child: _SaveButtonIfEdited(onSave: onSave),
            );
          },
        ),
      ],
    );
  }
}

class _SaveButtonIfEdited extends StatelessWidget {
  const _SaveButtonIfEdited({required this.onSave});
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSave,
      child: Text(
        LocaleKeys.home_profile_save.tr(),
        style: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
