import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/api/api_client.dart';
import 'package:sephsuu_care/core/api/api_exception.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/constants/app_gap.dart';
import 'package:sephsuu_care/core/constants/app_margin_size.dart';
import 'package:sephsuu_care/core/constants/app_padding_size.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/core/widgets/app_input.dart';
import 'package:sephsuu_care/core/widgets/app_screen_header.dart';
import 'package:sephsuu_care/core/widgets/app_snackbar.dart';
import 'package:sephsuu_care/helpers/loading_helper.dart';
import 'package:sephsuu_care/helpers/widgets/gradient_background.dart';
import 'package:sephsuu_care/services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _authService = AuthService(ApiClient());
  final _loading = LoadingHelper();

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    _loading.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading.isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      await _loading.run(() async {
        await _authService.changePassword(
          currentPassword: _currentPassword.text, 
          newPassword: _newPassword.text
        );

        if (!mounted) return;

        Navigator.of(context).pop(true);
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      AppSnackBar.error(
        context,
        error.message
      );
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.error(
        context,
        'Unable to change your password. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: _loading, 
            builder: (context, _) => 
              Column(
                children: [
                  const AppScreenHeader(
                    badge: AppHeaderBadge(
                      label: 'change password',
                      icon: Icons.lock_outline_rounded,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _ChangePasswordHeader(),
                          Padding(
                            padding: const EdgeInsetsGeometry.fromLTRB(
                              AppPadding.xl, AppPadding.x2l, AppPadding.xl, 0
                            ),
                            child: Column(
                              children: [
                                Form(
                                  key: _formKey,
                                  child: _ChangePasswordForm(
                                    currentPassword: _currentPassword, 
                                    newPassword: _newPassword, 
                                    confirmPassword: _confirmPassword, 
                                    isLoading: _loading.isLoading
                                  )
                                ),
                                _ChangePasswordWarning()
                              ],    
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.xl),
                    child: AppButton(
                      width: double.infinity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink,
                        foregroundColor: AppColors.light
                      ),
                      icon: const Icon(Icons.update),
                      label: const Text('Update Password'),
                      loadingLabel: const Text('Updating...'),
                      onProcess: _loading.isLoading,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
          )
        ),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    bool confirm = false,
  }) {
    return AppInput(
      label: label,
      controller: controller,
      obscureText: true,
      enabled: !_loading.isLoading,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }

        if (confirm && value != _newPassword.text) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }
}


class _ChangePasswordHeader extends StatelessWidget {
  const _ChangePasswordHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: AppPadding.x2l),
      child: Center(
        child: Column(
          children: [
            AppHeader1(
              'Keep your account secure by updating your password.',
              style: TextStyle(
                fontSize: AppFontSize.x2l
              ),
              textAlign: .center,
            )
          ],
        ),
      ),
    );
  }
}

class _ChangePasswordForm extends StatelessWidget {
  final TextEditingController currentPassword;
  final TextEditingController newPassword;
  final TextEditingController confirmPassword;
  final bool isLoading;

  const _ChangePasswordForm({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: AppMargin.sm),
        borderColor: AppColors.light,
        borderWidth: 1.5,
        child: Column(
          children: [
            AppInput(
              label: 'Current Password',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
              hintText: 'Enter your current password',
              labelCharacter: Icon(
                Icons.lock,
                size: AppFontSize.lg,
                color: AppColors.pink,
              ),
              controller: currentPassword,
              obscureText: true,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppGap.xl),
            AppInput(
              label: 'New Password',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
              hintText: 'Enter your new password',
              labelCharacter: Icon(
                Icons.lock,
                size: AppFontSize.lg,
                color: AppColors.pink,
              ),
              controller: newPassword,
              obscureText: true,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required';
                }
                if (value.length < 8) {
                  return 'Use at least 8 character password';
                }
                return null;
              },
            ),
            const SizedBox(height: AppGap.sm),
            Row(
              children: [
                const SizedBox(width: AppGap.xs),
                Icon(
                  Icons.check_circle,
                  size: AppFontSize.sm,
                  color: AppColors.pink,
                ),
                const SizedBox(width: AppGap.sm),
                Text(
                  'Use at least 8 characters long password.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: AppFontSize.xs
                  ),
                )
              ],
            ),
            const SizedBox(height: AppGap.lg),
            AppInput(
              label: 'Confirm Password',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
              hintText: 'Confirm new password',
              labelCharacter: Icon(
                Icons.lock,
                size: AppFontSize.lg,
                color: AppColors.pink,
              ),
              controller: confirmPassword,
              obscureText: true,
              enabled: !isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != newPassword.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            )
          ],
        )
      ),
    );
    
  }
}

class _ChangePasswordWarning extends StatelessWidget {
  const _ChangePasswordWarning();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      backgroundColor: const Color.fromARGB(255, 255, 240, 243),
      margin: const EdgeInsets.symmetric(vertical: AppMargin.sm),
      borderColor: AppColors.light,
      borderWidth: 1.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.pink,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning, color: AppColors.light, size: AppFontSize.xl),
          ),
          const SizedBox(width: AppGap.xl),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Your secutiry matters\n',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text: 'A strong password helps keep your personal health information safe and secure.',
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

