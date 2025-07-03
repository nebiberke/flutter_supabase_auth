import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/status_color_constants.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    required this.radius,
    this.avatarUrl,
    this.fallbackText,
    this.backgroundColor,
    this.fallbackIcon = Icons.person,
    super.key,
  });

  final double radius;
  final String? avatarUrl;
  final String? fallbackText;
  final Color? backgroundColor;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade200,
      child: _buildAvatarContent(context),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    /// If avatarUrl is not null and not empty, show CachedNetworkImage.
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: avatarUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: radius / 2,
            height: radius / 2,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            size: radius * 0.8,
            color: StatusColorConstants.errorColor,
          ),
        ),
      );
    }

    /// If fallbackText is not null and not empty, show Text.
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      return Text(
        fallbackText![0].toUpperCase(),
        style: context.textTheme.titleMedium?.copyWith(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      );
    }

    /// If fallbackText is null or empty, show fallback icon.
    return Icon(fallbackIcon, size: radius * 0.8, color: Colors.grey.shade600);
  }
}
