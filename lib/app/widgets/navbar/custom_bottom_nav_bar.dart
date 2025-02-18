import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

final class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: context.colorScheme.primary.withAlpha(50),
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'home.tabs.dashboard'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_rounded),
          label: 'home.tabs.profile'.tr(),
        ),
      ],
      selectedItemColor: context.colorScheme.secondary,
      unselectedItemColor: context.colorScheme.primary,
    );
  }
}
