import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/constants/padding_constants.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';
import 'package:flutter_supabase_auth/app/theme/cubit/theme_cubit.dart';
import 'package:flutter_supabase_auth/app/widgets/button/custom_outlined_button.dart';
import 'package:flutter_supabase_auth/app/widgets/circle_avatar/custom_circle_avatar.dart';
import 'package:flutter_supabase_auth/app/widgets/overlay/loading_overlay.dart';
import 'package:flutter_supabase_auth/app/widgets/text_field/custom_text_field.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';
import 'package:flutter_supabase_auth/core/mixins/error_handler_mixin.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/views/mixins/profile_view_mixin.dart';

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

class _ProfileViewState extends State<ProfileView>
    with ProfileViewMixin, ErrorHandlerMixin {
  @override
  Widget build(BuildContext context) {
    final user = context.select((ProfileBloc bloc) => bloc.state.profile);

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(listener: onProfileUpdateState),
        BlocListener<AuthBloc, AuthState>(
          listener: onAuthError,
          listenWhen: onAuthListenWhen,
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: _ProfileAppBar(
                  onThemeChanged: onThemeChanged,
                  isEditedNotifier: isEditedNotifier,
                  onSave: () => onSaveFullName(user),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: PaddingConstants.allHigh.r,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          context.verticalSpacingLow,
                          _ProfileImage(
                            avatarUrl: user.avatarUrl,
                            onTap: () => showImageSourceDialog(user),
                          ),
                          context.verticalSpacingLow,
                          _FullNameTextField(
                            controller: fullNameController,
                            onChanged: onFullNameChanged,
                          ),
                          context.verticalSpacingLow,
                          _EmailTextField(email: user.email),
                          context.verticalSpacingHigh,
                          _LanguageAndLogoutRow(
                            onLanguageSelected: showLanguageDialog,
                            onLogout: onLogout,
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
      ),
    );
  }
}
