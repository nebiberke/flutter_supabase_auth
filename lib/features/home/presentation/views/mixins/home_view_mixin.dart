import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/app/widgets/error/custom_error_widget.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_supabase_auth/features/home/presentation/views/home_view.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile/profile_state.dart';

mixin HomeViewMixin on State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<AllProfilesBloc>().add(const GetAllProfilesEvent());
  }

  void handleProfileState(BuildContext context, ProfileState state) {
    if (state.status == BlocStatus.error) {
      CustomErrorWidget.show<void>(context, failure: state.failure!);
    }
  }

  void handleAuthState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.error) {
      CustomErrorWidget.show<void>(context, failure: state.failure!);
    }
  }
}
