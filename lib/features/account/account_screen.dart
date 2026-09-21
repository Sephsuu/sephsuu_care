import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/api/api_client.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_avatar.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/core/widgets/app_screen_header.dart';
import 'package:sephsuu_care/core/widgets/app_snackbar.dart';
import 'package:sephsuu_care/features/auth/login_screen.dart';
import 'package:sephsuu_care/helpers/navigation_helper.dart';
import 'package:sephsuu_care/helpers/widgets/gradient_background.dart';
import 'package:sephsuu_care/services/auth_service.dart';
import 'package:sephsuu_care/services/user_service.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppScreenHeader(
                    badge: AppHeaderBadge(
                      label: 'my account',
                      icon: Icons.person_rounded,
                    )
                  ),
                  _AccountHeader(),
                  _PersonalInformation(),
                  _AccountDetails(),
                  _Logout(),
                ],
              )
            ),
          )
        )
      ),
    );
  }

}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AppAvatar(
            size: 120,
            backgroundColor: AppColors.pink,
            fallbackStyle: const TextStyle(
              color: AppColors.light,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
            borderWidth: 3,
          ),
          const SizedBox(height: 5),
          Text(
            'Joseph Emanuel O. Bataller',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: AppFontSize.xl
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'batallerjem208@gmail.com',
            style: TextStyle(
              color: AppColors.gray,
            ),
          )
        ],
      ),
    );
  }
}

class _PersonalInformation extends StatefulWidget {
  const _PersonalInformation();

  @override
  State<_PersonalInformation> createState() => _PeronalInformationState();
}

class _PeronalInformationState extends State<_PersonalInformation> {
  final _userService = UserService(ApiClient());
  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();

    _userFuture = _userService.getCurrentUser();
  }

  void _retry() {
    setState(() {
      _userFuture = _userService.getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
     final List<Map<String, dynamic>> _personalInfo = [
      {
        'icon': Icons.person_outline_rounded,
        'label': 'Full Name',
        'value': 'Sarah Mitchell',
      },
      {
        'icon': Icons.alternate_email,
        'label': 'Username',
        'value': 'Sephsuu',
      },
      {
        'icon': Icons.phone_outlined,
        'label': 'Contact Number',
        'value': '+1 987 654 3210',
      },
      {
        'icon': Icons.calendar_today_outlined,
        'label': 'Date of Birth',
        'value': '12 Mar 1995',
      },
      {
        'icon': Icons.male_rounded,
        'label': 'Gender',
        'value': 'Female',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 11, 22, 0),
      child: Center(
        child: AppCard(
          width: double.infinity,
          backgroundColor: Color.alphaBlend(
            AppColors.lightpink.withValues(alpha: 0.15),
            AppColors.light,
          ),
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          borderColor: AppColors.light,
          borderWidth: 1.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeaderBadge(
                label: 'Personal Information',
                icon: Icons.person,
                boxShadow: AppClay.lightShadows,
              ),
              const SizedBox(height: 10),
              ..._personalInfo.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == _personalInfo.length - 1;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),

                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: AppColors.pink,
                        size: 20,
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['label'] as String,
                              style: const TextStyle(
                                fontSize: AppFontSize.xs,
                                color: AppColors.dark,
                              ),
                            ),

                            Text(
                              item['value'] as String,
                              style: const TextStyle(
                                fontSize: AppFontSize.xs,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.gray,
                        size: 20,
                      ),
                    ],
                  ),
                );
              }),
            ],
          )
        ),
      ) 
    );
  }
}

class _AccountDetails extends StatelessWidget {
  const _AccountDetails();

  @override
  Widget build(BuildContext context) {
     final List<Map<String, dynamic>> _accountDetails = [
      {
        'icon': Icons.key_outlined,
        'label': 'Change Password',
      },
      {
        'icon': Icons.notifications_active_outlined,
        'label': 'Notifications',
      },
      {
        'icon': Icons.help_outline,
        'label': 'Date of Birth',
        'value': 'Help and Support',
      }
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 11, 22, 0),
      child: Center(
        child: AppCard(
          width: double.infinity,
          backgroundColor: Color.alphaBlend(
            AppColors.lightGreen.withValues(alpha: 0.70),
            AppColors.light,
          ),
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          borderColor: AppColors.light,
          borderWidth: 1.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeaderBadge(
                label: 'Account Details',
                icon: Icons.lock,
                iconColor: AppColors.mint,
                boxShadow: AppClay.lightShadows,
              ),
              const SizedBox(height: 10),
              ..._accountDetails.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == _accountDetails.length - 1;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),

                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: AppColors.mint,
                        size: 20,
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontSize: AppFontSize.xs,
                            color: AppColors.dark,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.gray,
                        size: 20,
                      ),
                    ],
                  ),
                );
              }),
            ],
          )
        ),
      ) 
    );
  }
}

class _Logout extends StatefulWidget {
  const _Logout();

  @override
  State<_Logout> createState() => _LogoutState();
}

class _LogoutState extends State<_Logout> {
  final _authService = AuthService(ApiClient());
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await _authService.logout();

      if (!mounted) return;

      NavigationHelper.redirect(context, const LoginScreen());
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.error(
        context, 
        'Unable to log out. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(22, 11, 22, 40),
      child: Center(
        child: AppButton(
          width: double.infinity,
          label: Text('Logout'),
          loadingLabel: Text('Logging out'),
          actionType: AppButtonActionType.delete,
          icon: const Icon(
            Icons.logout
          ),
          onPressed: _handleLogout,
        ),
      ),
    );
  }
}
