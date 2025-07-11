import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/features/home/presentation/views/home_view.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_event.dart';

mixin HomeViewMixin on State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<AllProfilesBloc>().add(const GetAllProfilesEvent());
  }
}
