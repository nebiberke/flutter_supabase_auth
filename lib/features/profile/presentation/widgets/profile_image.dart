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
          CircleAvatar(
            radius: 60.r,
            backgroundColor: Colors.grey.shade200,
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: ThemeConstants.borderRadiusCircular60,
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl!,
                      width: 60 * 2.r,
                      height: 60 * 2.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        size: 60.r,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 60.r,
                    color: Colors.grey.shade600,
                  ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: context.paddingAllLow / 3,
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
