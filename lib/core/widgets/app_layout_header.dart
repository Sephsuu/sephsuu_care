import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/widgets/app_avatar.dart';
import 'package:sephsuu_care/features/account/account_screen.dart';
import 'package:sephsuu_care/helpers/navigation_helper.dart';
import 'package:sephsuu_care/helpers/widgets/stroked_text.dart';

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
        Semantics(
          button: true,
          label: '$username profile',
          child: InkWell(
            onTap: () {
              NavigationHelper.push(context, AccountScreen());
            },
            customBorder: const CircleBorder(),
            child: AppAvatar(
              size: 46,
              fallback: initial,
              backgroundColor: AppColors.pink,
              fallbackStyle: const TextStyle(color: AppColors.light),
            ),
          ),
        ),
        const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StrokedText(
                text: 'Sephsuu',
                fontSize: 22,
                fillColor: AppColors.pink,
                strokeColor: AppColors.light,
                strokeWidth: 2,
              ),
              SizedBox(width: 2),
              StrokedText(
                text: 'Care',
                fontSize: 22,
                fillColor: AppColors.lightpink,
                strokeColor: AppColors.gray,
                strokeWidth: 1,
              ),
            ],
          ),
        ),
        Semantics(
          button: true,
          label: hasUnreadNotifications
              ? 'Notifications, unread notifications available'
              : 'Notifications',
          child: Material(
            color: Colors.white,
            elevation: 6,
            shadowColor: AppClay.shadow,
            surfaceTintColor: Colors.transparent,
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
        ),
      ],
    );
  }
}
