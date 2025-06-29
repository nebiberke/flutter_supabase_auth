import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/constants/padding_constants.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';
import 'package:flutter_supabase_auth/app/widgets/circle_avatar/custom_circle_avatar.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';
import 'package:flutter_supabase_auth/features/home/presentation/bloc/users_bloc.dart';
import 'package:flutter_supabase_auth/features/home/presentation/bloc/users_event.dart';
import 'package:flutter_supabase_auth/features/home/presentation/bloc/users_state.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({required this.userId, super.key});

  final String userId;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(GetProfileWithIdEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.user_profile_title.tr())),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.selectedProfile == null) {
            return Center(child: Text(LocaleKeys.user_profile_not_found.tr()));
          }

          return _buildProfileDetails(context, state.selectedProfile!);
        },
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, ProfileEntity profile) {
    return SingleChildScrollView(
      padding: PaddingConstants.allHigh(),
      child: Column(
        children: [
          CustomCircleAvatar(
            radius: 50.r,
            avatarUrl: profile.avatarUrl,
            fallbackText: profile.fullName,
          ),
          context.verticalSpacingLow,
          Text(profile.fullName, style: context.textTheme.headlineSmall),
          context.verticalSpacingLow,
          Text(
            '@${profile.username}',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          context.verticalSpacingLow,
          _buildInfoCard(
            context,
            title: LocaleKeys.auth_fields_email.tr(),
            content: profile.email,
            icon: Icons.email,
          ),
          context.verticalSpacingLow,
          _buildInfoCard(
            context,
            title: LocaleKeys.user_profile_user_id.tr(),
            content: profile.id,
            icon: Icons.person_pin,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: PaddingConstants.allMedium(),
        child: Row(
          children: [
            Icon(icon, color: context.colorScheme.primary),
            context.horizontalSpacingLow,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(content, style: context.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
