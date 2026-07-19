import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/widgets/app_avatar.dart';

class AppLayoutHeader extends StatelessWidget {
  final String username;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;
  final bool hasUnreadNotifications;

  const AppLayoutHeader({
    super.key,
    required this.username,
    this.onProfileTap,
    this.onNotificationsTap,
    this.hasUnreadNotifications = true,
  });

  @override
  Widget build(BuildContext context) {
    final initial = username.trim().isEmpty
        ? '?'
        : username.trim().characters.first.toUpperCase();

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  AppAvatar(
                    size: 46,
                    fallback: initial,
                    backgroundColor: AppColors.lightpink,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            color: AppColors.gray,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onNotificationsTap,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: 46,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.dark,
                    size: 25,
                  ),
                  if (hasUnreadNotifications)
                    Positioned(
                      right: 11,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.pink,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
