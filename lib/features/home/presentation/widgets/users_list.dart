part of '../views/home_view.dart';

final class _UsersList extends StatelessWidget {
  const _UsersList();

  void _navigateToUserProfile(BuildContext context, String userId) {
    context.pushNamed(AppRouter.userProfile, pathParameters: {'id': userId});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.home_users.tr(),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          context.verticalSpacingHigh,
          Expanded(
            child: BlocConsumer<AllProfilesBloc, AllProfilesState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status &&
                  current.status == BlocStatus.error,
              listener: (context, state) {
                if (state.status == BlocStatus.error && state.failure != null) {
                  CustomErrorWidget.show<void>(
                    context,
                    failure: state.failure!,
                  );
                }
              },
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.profiles != current.profiles,
              builder: (context, state) {
                if (state.status == BlocStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.profiles.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Text(LocaleKeys.home_no_users.tr()),
                        context.verticalSpacingMedium,
                        TextButton(
                          onPressed: () {
                            context.read<AllProfilesBloc>().add(
                              const GetAllProfilesEvent(),
                            );
                          },
                          child: Text(LocaleKeys.home_refresh.tr()),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AllProfilesBloc>().add(
                      const GetAllProfilesEvent(),
                    );
                  },
                  child: ListView.builder(
                    itemCount: state.profiles.length,

                    itemBuilder: (context, index) {
                      final user = state.profiles[index];
                      return _UserListItem(
                        profile: user,
                        onTap: () => _navigateToUserProfile(context, user.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final class _UserListItem extends StatelessWidget {
  const _UserListItem({required this.profile, required this.onTap});

  final ProfileEntity profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = 20.r;
    return Card(
      margin: PaddingConstants.verticalLow + PaddingConstants.horizontalLow,
      child: ListTile(
        onTap: onTap,
        leading: CustomCircleAvatar(
          radius: avatarRadius,
          avatarUrl: profile.avatarUrl,
          fallbackText: profile.fullName,
        ),
        title: Text(profile.fullName),
        subtitle: Text(profile.username),
      ),
    );
  }
}
