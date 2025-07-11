import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/constants/padding_constants.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';
import 'package:flutter_supabase_auth/app/router/app_router.dart';
import 'package:flutter_supabase_auth/app/widgets/circle_avatar/custom_circle_avatar.dart';
import 'package:flutter_supabase_auth/app/widgets/error/custom_error_widget.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';
import 'package:flutter_supabase_auth/core/mixins/error_handler_mixin.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_supabase_auth/features/home/presentation/views/mixins/home_view_mixin.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:go_router/go_router.dart';

part '../widgets/users_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with HomeViewMixin, ErrorHandlerMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: onProfileError,
          listenWhen: onProfileListenWhen,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: onAuthError,
          listenWhen: onAuthListenWhen,
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: PaddingConstants.allHigh.r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _WelcomeTitle(),
                context.verticalSpacingVeryHigh2x,
                Text(
                  LocaleKeys.home_dashboard_description.tr(),
                  style: context.textTheme.titleMedium,
                ),

                context.verticalSpacingVeryHigh2x,
                const _UsersList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _WelcomeTitle extends StatelessWidget {
  const _WelcomeTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProfileBloc, ProfileState, ProfileEntity>(
      selector: (state) {
        return state.profile;
      },
      builder: (context, profile) {
        return Text(
          LocaleKeys.home_welcome.tr(args: [profile.fullName]),
          style: context.textTheme.headlineMedium,
        );
      },
    );
  }
}
