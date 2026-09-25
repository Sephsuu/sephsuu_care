import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/api/api_client.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/constants/app_margin_size.dart';
import 'package:sephsuu_care/core/widgets/app_avatar.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_empty_state.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/core/widgets/app_modal.dart';
import 'package:sephsuu_care/core/widgets/app_screen_header.dart';
import 'package:sephsuu_care/core/widgets/app_section_loading.dart';
import 'package:sephsuu_care/core/widgets/app_snackbar.dart';
import 'package:sephsuu_care/features/account/edit_account_screen.dart';
import 'package:sephsuu_care/features/account/account_detail.dart';
import 'package:sephsuu_care/features/auth/change_password_screen.dart';
import 'package:sephsuu_care/features/auth/login_screen.dart';
import 'package:sephsuu_care/helpers/date_helper.dart';
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
          child: Column(
            children: [
              AppScreenHeader(
                badge: AppHeaderBadge(
                  label: 'my account',
                  icon: Icons.person_rounded,
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_AccountProfile(), _AccountDetails(), _Logout()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.user});

  final Map<String, dynamic> user;

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
          AppHeader1(
            user['full_name']?.toString() ?? '—',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSize.x2l,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            user['email']?.toString() ?? '—',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}

class _AccountProfile extends StatefulWidget {
  const _AccountProfile();

  @override
  State<_AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<_AccountProfile> {
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _userFuture,
      builder: ((context, snapshot) {
        final user = snapshot.data;

        final personalInfo = [
          {
            'icon': Icons.person_outline_rounded,
            'label': 'Full Name',
            'detail': AccountDetail.fullName,
            'value': user?['full_name']?.toString() ?? '—',
          },
          {
            'icon': Icons.alternate_email,
            'label': 'Username',
            'value': user?['username']?.toString() ?? '—',
          },
          {
            'icon': Icons.phone_outlined,
            'label': 'Contact Number',
            'detail': AccountDetail.contactNumber,
            'value': user?['contact_number']?.toString() ?? '—',
          },
          {
            'icon': Icons.calendar_today_outlined,
            'label': 'Date of Birth',
            'detail': AccountDetail.dateOfBirth,
            'value': DateHelper.formatApiDateToWords(
              user?['date_of_birth']?.toString(),
              fallback: '—',
            ),
          },
          {
            'icon': Icons.person_outline,
            'label': 'Gender',
            'detail': AccountDetail.gender,
            'value': user?['gender']?.toString() ?? '—',
          },
        ];

        return AppSectionLoading(
          isLoading: snapshot.connectionState != ConnectionState.done,
          onRetry: _retry,
          errorMessage: snapshot.hasError ? snapshot.error.toString() : null,
          isEmpty: user == null || user.isEmpty,
          emptyWidget: const AppEmptyState(
            title: 'No profile details',
            icon: Icons.person_outline_rounded,
          ),
          child: Column(
            children: [
              _AccountHeader(user: user ?? const {}),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 11, 22, 0),
                child: Center(
                  child: AppCard(
                    width: double.infinity,
                    backgroundColor: Color.alphaBlend(
                      AppColors.lightpink.withValues(alpha: 0.15),
                      AppColors.light,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: AppMargin.sm),
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
                        ...personalInfo.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final isLast = index == personalInfo.length - 1;

                          final detail = item['detail'] as AccountDetail?;

                          return InkWell(
                            onTap: detail == null || user == null
                                ? null
                                : () async {
                                    final saved =
                                        await NavigationHelper.push<bool>(
                                          context,
                                          EditAccountScreen(
                                            detail: detail,
                                            initialValue: user[detail.apiKey]
                                                ?.toString(),
                                          ),
                                        );

                                    if (!mounted ||
                                        !context.mounted ||
                                        saved != true) {
                                      return;
                                    }

                                    _retry();

                                    AppSnackBar.success(
                                      context,
                                      'Profile updated successfully.',
                                    );
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),

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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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

                                  Icon(
                                    detail == null
                                        ? Icons.lock_outline_rounded
                                        : Icons.chevron_right_rounded,
                                    color: AppColors.gray,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
        'onTap': () async {
          final updated = await NavigationHelper.push(
            context,
            const ChangePasswordScreen()
          );

          if (!context.mounted) return;

          if (updated == true) {
            AppSnackBar.success(
              context, 
              'Password updated successfulluy.'
            );
          }
        }
      },
      {'icon': Icons.notifications_active_outlined, 'label': 'Notifications'},
      {
        'icon': Icons.help_outline,
        'label': 'Date of Birth',
        'value': 'Help and Support',
      },
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

                return InkWell(
                  onTap: item["onTap"] as VoidCallback?,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),

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
                  )
                );
              }),
            ],
          ),
        ),
      ),
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
  bool _isConfirmLogout = false;

  Future<void> _confirmLogout() async {
    if (_isConfirmLogout || _isLoggingOut) return;

    _isConfirmLogout = true;


    try {
      final confirmed = await AppModal.show(
        context, 
        builder: (modalContext) => AppModal(
          title: 'Log out?', 
          child: Text(
            'Are you sure you want to log out of your account?',
          ),
          actions: [
            AppButton(
              label: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.light,
                foregroundColor: AppColors.dark
              ),
            ),
            AppButton(
              label: Text('Log out'),
              borderColor: AppColors.light,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.light
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        )
      );

      if (!mounted || confirmed != true) return;

      await _handleLogout();
    } finally {
      _isConfirmLogout = false;
    }
  }

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

      AppSnackBar.error(context, 'Unable to log out. Please try again.');
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
          icon: const Icon(Icons.logout),
          onProcess: _isLoggingOut,
          onPressed: _confirmLogout,
        ),
      ),
    );
  }
}
