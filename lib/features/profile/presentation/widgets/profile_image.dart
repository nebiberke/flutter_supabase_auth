part of '../views/profile_view.dart';

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({
    required this.avatarUrl,
    required this.onTap,
  });
  final String? avatarUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CustomCircleAvatar(
            radius: 60.r,
            avatarUrl: avatarUrl,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: PaddingConstants.allLow() / 3,
              decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 24.sp,
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
