import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/api/api_client.dart';
import 'package:sephsuu_care/core/api/api_exception.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_date_picker.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/core/widgets/app_input.dart';
import 'package:sephsuu_care/core/widgets/app_radio_group.dart';
import 'package:sephsuu_care/core/widgets/app_snackbar.dart';
import 'package:sephsuu_care/features/initial/known_allergies_screen.dart';
import 'package:sephsuu_care/helpers/date_helper.dart';
import 'package:sephsuu_care/helpers/validators/input_validator.dart';
import 'package:sephsuu_care/services/auth_service.dart';

class RegistrationFormScreen extends StatefulWidget {
  final String? role;

  const RegistrationFormScreen({super.key, this.role});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _authService = AuthService(ApiClient());

  DateTime? _dateOfBirth;
  String? _gender;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  String get _roleLabel {
    final role = widget.role;
    if (role == null || role.isEmpty) return 'new member';
    return role[0].toUpperCase() + role.substring(1);
  }

  String _formatSubmitError(Object error) {
    if (error is! ApiException) return error.toString();

    final fieldErrors = error.errors?.values
        .whereType<List>()
        .expand((messages) => messages)
        .map((message) => message.toString())
        .where((message) => message.isNotEmpty)
        .toList();

    if (fieldErrors != null && fieldErrors.isNotEmpty) {
      return fieldErrors.first;
    }

    return error.message;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final registeredUser = await _authService.register(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        role: widget.role ?? 'patient',
        contactNumber: _contactNumberController.text.trim(),
        dateOfBirth: DateHelper.formatApiDate(_dateOfBirth!),
        gender: _gender!,
      );

      if (!mounted) return;
      AppSnackBar.success(
        context,
        'Account created for ${registeredUser['user']?['full_name'] ?? _roleLabel}',
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => const KnownAllergiesScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.error(context, _formatSubmitError(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 820;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE6EE), Color(0xFFF7FBFF), Color(0xFFE3F7EE)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 56 : 22,
              vertical: isWide ? 36 : 22,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Back',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(height: 18),
                    _RegistrationHeader(roleLabel: _roleLabel),
                    const SizedBox(height: 24),
                    AppCard(
                      borderRadius: 8,
                      padding: EdgeInsets.all(isWide ? 26 : 18),
                      backgroundColor: AppColors.light.withValues(alpha: 0.9),
                      borderColor: AppColors.light,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dark.withValues(alpha: 0.08),
                          blurRadius: 28,
                          offset: const Offset(0, 16),
                        ),
                      ],
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ResponsiveFields(
                              isWide: isWide,
                              children: [
                                AppInput(
                                  label: 'Full name',
                                  controller: _fullNameController,
                                  hintText: 'Juan Dela Cruz',
                                  textInputAction: TextInputAction.next,
                                  labelCharacter: const Icon(
                                    Icons.person,
                                    size: AppFontSize.lg,
                                    color: AppColors.pink,
                                  ),
                                  fillColor: AppColors.light,
                                  borderColor: AppColors.lightpink,
                                  focusedBorderColor: AppColors.pink,
                                  borderRadius: 8,
                                  validator: (value) =>
                                      InputValidator.requiredText(
                                        value,
                                        'Full name',
                                      ),
                                ),
                                AppInput(
                                  label: 'Username',
                                  controller: _usernameController,
                                  hintText: 'sefi_care',
                                  textInputAction: TextInputAction.next,
                                  labelCharacter: const Icon(
                                    Icons.alternate_email_rounded,
                                    size: AppFontSize.lg,
                                    color: AppColors.pink,
                                  ),
                                  fillColor: AppColors.light,
                                  borderColor: AppColors.lightpink,
                                  focusedBorderColor: AppColors.pink,
                                  borderRadius: 8,
                                  validator: (value) =>
                                      InputValidator.requiredText(
                                        value,
                                        'Username',
                                      ),
                                ),
                                AppInput(
                                  label: 'Email',
                                  controller: _emailController,
                                  hintText: 'name@example.com',
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  labelCharacter: const Icon(
                                    Icons.mail_outline_rounded,
                                    size: AppFontSize.lg,
                                    color: AppColors.pink,
                                  ),
                                  fillColor: AppColors.light,
                                  borderColor: AppColors.lightpink,
                                  focusedBorderColor: AppColors.pink,
                                  borderRadius: 8,
                                  validator: InputValidator.email,
                                ),
                                AppDatePicker(
                                  label: 'Date of birth',
                                  value: _dateOfBirth,
                                  placeholder: 'Select birthday',
                                  fillColor: AppColors.light,
                                  borderColor: AppColors.lightpink,
                                  focusedBorderColor: AppColors.pink,
                                  required: true,
                                  formatter: DateHelper.formatDisplayDate,
                                  onChanged: (date) {
                                    setState(() => _dateOfBirth = date);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: AppRadioGroup<String>(
                                label: 'Gender',
                                value: _gender,
                                required: true,
                                activeColor: AppColors.pink,
                                bordered: true,
                                fillColor: AppColors.light,
                                borderColor: AppColors.border,
                                alignment: WrapAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                onChanged: (value) {
                                  setState(() => _gender = value);
                                },
                                options: const [
                                  AppRadioOption(label: 'Male', value: 'male'),
                                  AppRadioOption(
                                    label: 'Female',
                                    value: 'female',
                                  ),
                                  AppRadioOption(
                                    label: 'Others',
                                    value: 'others',
                                  ),
                                  AppRadioOption(
                                    label: 'Prefer not to say',
                                    value: 'prefer_not_to_say',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: isWide ? 395 : double.infinity,
                              child: AppInput(
                                label: 'Contact number',
                                controller: _contactNumberController,
                                hintText: '0917 123 4567',
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                labelCharacter: const Icon(
                                  Icons.phone_outlined,
                                  size: AppFontSize.lg,
                                  color: AppColors.pink,
                                ),
                                fillColor: AppColors.light,
                                borderColor: AppColors.lightpink,
                                focusedBorderColor: AppColors.pink,
                                borderRadius: 8,
                                validator: (value) => InputValidator.phone(
                                  value,
                                  'contact number',
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              width: double.infinity,
                              onProcess: _isSubmitting,
                              icon: const Icon(
                                Icons.favorite_rounded,
                                size: 19,
                              ),
                              label: const Text(
                                'create account',
                                style: TextStyle(
                                  fontSize: AppFontSize.base,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              loadingLabel: const Text(
                                'Saving details...',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.pink,
                                foregroundColor: AppColors.light,
                                disabledBackgroundColor: AppColors.pink
                                    .withValues(alpha: 0.6),
                                disabledForegroundColor: AppColors.light
                                    .withValues(alpha: 0.8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationHeader extends StatelessWidget {
  final String roleLabel;

  const _RegistrationHeader({required this.roleLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeaderBadge(
          label: '${roleLabel.toLowerCase()} signup',
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          textStyle: const TextStyle(
            color: AppColors.dark,
            fontSize: AppFontSize.xs,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),
        const AppHeader1('tell us about you'),
        const SizedBox(height: 8),
        Text(
          'these details help Sephsuu Care shape your account and prepare your generated login.',
          style: const TextStyle(
            color: AppColors.gray,
            fontSize: AppFontSize.base,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  final bool isWide;
  final List<Widget> children;

  const _ResponsiveFields({required this.isWide, required this.children});

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        children: [
          for (final child in children) ...[
            child,
            if (child != children.last) const SizedBox(height: 16),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final child in children) SizedBox(width: 395, child: child),
      ],
    );
  }
}
