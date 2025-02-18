import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/constants/theme_constants.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';
import 'package:flutter_supabase_auth/app/theme/cubit/theme_cubit.dart';
import 'package:flutter_supabase_auth/app/widgets/button/custom_outlined_button.dart';
import 'package:flutter_supabase_auth/app/widgets/overlay/loading_overlay.dart';
import 'package:flutter_supabase_auth/app/widgets/text_field/custom_text_field.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/views/profile_view_mixin.dart';

part '../widgets/email_text_field.dart';
part '../widgets/full_name_text_field.dart';
part '../widgets/language_and_logout_row.dart';
part '../widgets/profile_app_bar.dart';
part '../widgets/profile_image.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with ProfileViewMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeUserData());
  }

  void _initializeUserData() {
    final user = context.read<ProfileBloc>().state.profile;
    if (user.fullName.isNotEmpty) {
      fullNameController.text = user.fullName;
      initialFullName = user.fullName;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    isEditedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((ProfileBloc bloc) => bloc.state.profile);

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: handleProfileState,
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: _ProfileAppBar(
                onThemeChanged: handleThemeChanged,
                isEditedNotifier: isEditedNotifier,
                onSave: () => saveFullName(user),
              ),
              body: SafeArea(
                child: Padding(
                  padding: context.paddingAllDefault,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        context.verticalSpacingDefault,
                        _ProfileImage(
                          avatarUrl: user.avatarUrl,
                          onTap: () => showImageSourceDialog(user),
                        ),
                        context.verticalSpacingDefault,
                        _FullNameTextField(
                          controller: fullNameController,
                          onChanged: onFullNameChanged,
                        ),
                        context.verticalSpacingLow,
                        _EmailTextField(email: user.email),
                        context.verticalSpacingHigh,
                        _LanguageAndLogoutRow(
                          onLanguageSelected: showLanguageDialog,
                          onLogout: handleLogout,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state.status == BlocStatus.loading) const LoadingOverlay(),
          ],
        );
      },
    );
  }
}
