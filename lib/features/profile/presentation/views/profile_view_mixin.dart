import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';
import 'package:flutter_supabase_auth/app/theme/cubit/theme_cubit.dart';
import 'package:flutter_supabase_auth/app/widgets/error/custom_error_widget.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/enums/snackbar_state.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/core/utils/snackbar/snackbar_utils.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/views/profile_view.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

mixin ProfileViewMixin on State<ProfileView> {
  /// A controller for the full name text field.
  late final TextEditingController fullNameController = TextEditingController();

  /// An image picker instance.
  final ImagePicker imagePicker = ImagePicker();

  /// The initial full name of the user.
  String? initialFullName;

  /// A notifier to indicate whether the full name is edited.
  final ValueNotifier<bool> isEditedNotifier = ValueNotifier(false);

  /// Inıt State
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeUserData());
  }

  /// Initialize User Data
  void _initializeUserData() {
    final user = context.read<ProfileBloc>().state.profile;
    if (user.fullName.isNotEmpty) {
      fullNameController.text = user.fullName;
      initialFullName = user.fullName;
    }
  }

  /// Dispose
  @override
  void dispose() {
    fullNameController.dispose();
    isEditedNotifier.dispose();
    super.dispose();
  }

  /// Handles the sign out event.
  void handleLogout() {
    context.read<AuthBloc>().add(SignOutEvent());
  }

  /// Handles the profile update state changes event.
  void handleProfileUpdateState(BuildContext context, ProfileState state) {
    if (state.status == BlocStatus.error) {
      CustomErrorWidget.show<void>(context, failure: state.failure!);
    } else if (state.status == BlocStatus.loaded) {
      SnackbarUtils.showSnackbar(
        context: context,
        message: LocaleKeys.home_profile_updated.tr(),
        state: SnackbarState.success,
      );
      fullNameController.text = state.profile.fullName;
      initialFullName = state.profile.fullName;
    }
  }

  /// Handles the theme changed event.
  void handleThemeChanged({required bool isLightTheme}) {
    context.read<ThemeCubit>().setThemeMode(
      isLightTheme ? ThemeMode.light : ThemeMode.dark,
    );
  }

  /// Shows the language dialog.
  void showLanguageDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(LocaleKeys.language_title.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(LocaleKeys.language_turkish.tr()),
              onTap: () {
                context
                  ..setLocale(const Locale('tr', 'TR'))
                  ..pop();
              },
            ),
            ListTile(
              title: Text(LocaleKeys.language_english.tr()),
              onTap: () {
                context
                  ..setLocale(const Locale('en', 'US'))
                  ..pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the full name text field changed event.
  void onFullNameChanged(String newFullName) {
    final trimmedFullName = newFullName.trim();
    isEditedNotifier.value = trimmedFullName != initialFullName;
  }

  /// Handles the full name text field submitted event.
  Future<void> saveFullName(ProfileEntity currentProfile) async {
    final newFullName = fullNameController.text.trim();
    if (newFullName.isEmpty) return;
    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        profile: currentProfile.copyWith(fullName: newFullName),
      ),
    );
    isEditedNotifier.value = false;
    initialFullName = newFullName;
  }

  /// Picks an image from the camera or gallery.
  Future<void> _pickImage(
    ImageSource source,
    ProfileEntity currentProfile,
  ) async {
    try {
      final imageFile = await imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (imageFile != null && mounted) {
        context.read<ProfileBloc>().add(
          UpdateProfileEvent(profile: currentProfile, imageFile: imageFile),
        );
      }
    } on Exception catch (e, stackTrace) {
      LoggerUtils().logFatalError('Error picking photo: $e', stackTrace);

      if (mounted) {
        SnackbarUtils.showSnackbar(
          context: context,
          message: LocaleKeys.errors_messages_auth_profile_photo_pick_failed
              .tr(),
          state: SnackbarState.error,
        );
      }
    }
  }

  /// Picks an image from the camera or gallery.
  void showImageSourceDialog(ProfileEntity currentProfile) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(LocaleKeys.home_profile_choose_photo.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(LocaleKeys.home_profile_camera.tr()),
              onTap: () {
                context.pop();
                _pickImage(ImageSource.camera, currentProfile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(LocaleKeys.home_profile_gallery.tr()),
              onTap: () {
                context.pop();
                _pickImage(ImageSource.gallery, currentProfile);
              },
            ),
          ],
        ),
      ),
    );
  }
}
