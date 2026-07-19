import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_bottom_navigation.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_layout_header.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/helpers/widgets/stroked_text.dart';

class UserDashboardScreen extends StatefulWidget {
  final String username;

  const UserDashboardScreen({super.key, this.username = 'there'});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  int _selectedIndex = 0;

  String _greetingForHour(int hour) {
    if (hour < 12) return 'Good morning ';
    if (hour < 18) return 'Good afternoon ';
    return 'Good evening ';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 760;
    final horizontalPadding = isWide ? 56.0 : 22.0;
    final welcomeHeight = math.max(150.0, size.height * .01);
    final greeting = _greetingForHour(DateTime.now().hour);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                isWide ? 24 : 14,
                horizontalPadding,
                12,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: AppLayoutHeader(
                    username: widget.username,
                    onProfileTap: () => setState(() => _selectedIndex = 3),
                    onNotificationsTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notifications are coming soon.'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  SingleChildScrollView(
                    key: const PageStorageKey('dashboard-home'),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      isWide ? 14 : 8,
                      horizontalPadding,
                      32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppHeaderBadge(
                              label: 'your care dashboard',
                              icon: Icons.favorite_rounded,
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              textStyle: TextStyle(
                                fontSize: AppFontSize.x2s,
                                fontWeight: FontWeight.w800,
                              ),
                              iconSize: 14,
                              gap: 5,
                            ),
                            _WelcomeSection(
                              greeting: greeting,
                              username: widget.username,
                              height: welcomeHeight,
                              isWide: isWide,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const _EmptyDashboardTab(
                    icon: Icons.favorite_border_rounded,
                    title: 'Your care',
                    message: 'Your care items will appear here.',
                  ),
                  const _EmptyDashboardTab(
                    icon: Icons.medical_services_outlined,
                    title: 'Health',
                    message: 'Your health records will appear here.',
                  ),
                  _EmptyDashboardTab(
                    icon: Icons.person_outline_rounded,
                    title: widget.username,
                    message: 'Your profile details will appear here.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _selectedIndex,
        onSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class _EmptyDashboardTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyDashboardTab({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.pink),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  final String greeting;
  final String username;
  final double height;
  final bool isWide;

  const _WelcomeSection({
    required this.greeting,
    required this.username,
    required this.height,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = isWide ? height * 1.5 : height;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: isWide ? 110 : -20,
          top: isWide ? -36 : -30,
          width: imageSize,
          height: imageSize,
          child: Image.asset(
            'assets/images/sefi_welcome.png',
            fit: BoxFit.contain,
            alignment: Alignment.topRight,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppHeader1(
                  greeting,
                  fontSize: isWide ? AppFontSize.x2l : AppFontSize.xl,
                ),
                StrokedText(
                  text: '$username!',
                  fontSize: isWide ? AppFontSize.x2l + 1 : AppFontSize.xl + 1,
                  fillColor: AppColors.pink,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              ],
            ),
            const Text(
              "Here's how your health is looking today.",
              style: TextStyle(
                color: AppColors.gray,
                fontSize: AppFontSize.x2s,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            _WelcomeCard(height: height, isWide: isWide),
          ],
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final double height;
  final bool isWide;

  const _WelcomeCard({required this.height, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AppCard(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.zero,
              borderColor: null,
              borderRadius: 30,
              backgroundColor: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: AppColors.pink.withValues(alpha: 0.10),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.lightpink, width: 1),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.light.withValues(alpha: 0.58),
                        AppColors.lightpink.withValues(alpha: 0.30),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 40 : 24,
                      vertical: isWide ? 34 : 26,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: isWide ? 0.58 : 0.62,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AppHeader1(
                            //   'Welcome to Sephsuu Care',
                            //   color: AppColors.dark,
                            //   fontSize: isWide
                            //       ? AppFontSize.x3l
                            //       : AppFontSize.x2l,
                            //   maxLines: 2,
                            // ),
                            // const SizedBox(height: 10),
                            // const Text(
                            //   'Your health, cared for anytime.',
                            //   style: TextStyle(
                            //     color: AppColors.gray,
                            //     fontSize: AppFontSize.sm,
                            //     height: 1.4,
                            //     fontWeight: FontWeight.w700,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
