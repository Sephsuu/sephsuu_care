import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/api/api_client.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/constants/app_gap.dart';
import 'package:sephsuu_care/core/constants/app_margin_size.dart';
import 'package:sephsuu_care/core/constants/app_padding_size.dart';
import 'package:sephsuu_care/core/widgets/app_avatar.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';

import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/core/widgets/app_input.dart';
import 'package:sephsuu_care/core/widgets/app_screen_header.dart';
import 'package:sephsuu_care/core/widgets/app_snackbar.dart';
import 'package:sephsuu_care/helpers/date_helper.dart';
import 'package:sephsuu_care/helpers/widgets/gradient_background.dart';

import 'package:sephsuu_care/core/widgets/app_date_picker.dart';
import 'package:sephsuu_care/core/widgets/app_radio_group.dart';
import 'package:sephsuu_care/features/account/account_detail.dart';
import 'package:sephsuu_care/helpers/validators/input_validator.dart';
import 'package:sephsuu_care/services/user_service.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key, required this.detail, this.initialValue});

  final AccountDetail detail;
  final String? initialValue;

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  DateTime? _dateOfBirth;
  String? _gender;

  final _userService = UserService(ApiClient());
  bool _isSaving = false;

  String _getValue() {
    return switch (widget.detail) {
      AccountDetail.fullName ||
      AccountDetail.contactNumber => _controller.text.trim(),
      AccountDetail.dateOfBirth =>
        DateHelper.formatApiDate(_dateOfBirth!),
      AccountDetail.gender => _gender!,
    };
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _userService.updateProfileDetails(
        widget.detail.apiKey, 
        _getValue()
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.error(
        context,
        'Unable to save changes. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    if (widget.detail == AccountDetail.dateOfBirth) {
      _dateOfBirth = DateTime.tryParse(widget.initialValue ?? '');
    }
    if (widget.detail == AccountDetail.gender) {
      _gender = widget.initialValue?.trim().toLowerCase();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppScreenHeader(
                badge: AppHeaderBadge(
                  label: 'edit ${widget.detail.label.toLowerCase()}',
                  icon: Icons.person_rounded,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _EditAccountHeader(detail: widget.detail),
                      const SizedBox(height: AppGap.x2l),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.sm,
                          horizontal: AppPadding.xl,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _DetailField(
                                detail: widget.detail,
                                controller: _controller,
                                dateOfBirth: _dateOfBirth,
                                gender: _gender,
                                onDateChanged: (value) =>
                                    setState(() => _dateOfBirth = value),
                                onGenderChanged: (value) =>
                                    setState(() => _gender = value),
                              ),
                              if (widget.detail == AccountDetail.fullName) ...[
                                const SizedBox(height: AppGap.xl),
                                const _FullNameWarning(),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppPadding.xl,
                  AppPadding.sm,
                  AppPadding.xl,
                  AppPadding.xl,
                ),
                child: AppButton(
                  width: double.infinity,
                  label: const Text('Save Changes'),
                  loadingLabel: Text('Saving Changes'),
                  // Enable when profile saving is connected.
                  onPressed: _saveChanges,
                  onProcess: _isSaving,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.light,
                    disabledBackgroundColor: AppColors.pink.withValues(
                      alpha: 0.6,
                    ),
                    disabledForegroundColor: AppColors.light.withValues(
                      alpha: 0.8,
                    ),
                    elevation: 0,
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

class _EditAccountHeader extends StatelessWidget {
  const _EditAccountHeader({required this.detail});

  final AccountDetail detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: AppPadding.xl),
      child: Center(
        child: Column(
          children: [
            AppAvatar(
              size: 120,
              backgroundColor: AppColors.pink,
              fallbackStyle: TextStyle(
                color: AppColors.light,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
              borderWidth: 3,
            ),
            const SizedBox(height: 5),
            Text(
              'Edit Your ${detail.label}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: AppFontSize.xl,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Update your ${detail.label.toLowerCase()} on your profile.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.detail,
    required this.controller,
    required this.dateOfBirth,
    required this.gender,
    required this.onDateChanged,
    required this.onGenderChanged,
  });

  final AccountDetail detail;
  final TextEditingController controller;
  final DateTime? dateOfBirth;
  final String? gender;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<String?> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    switch (detail) {
      case AccountDetail.fullName:
        return AppInput(
          label: detail.label,
          controller: controller,
          hintText: 'Enter your full name',
          keyboardType: TextInputType.name,
          validator: (value) =>
              InputValidator.requiredText(value, detail.label),
        );
      case AccountDetail.contactNumber:
        return AppInput(
          label: detail.label,
          controller: controller,
          hintText: 'Enter your contact number',
          keyboardType: TextInputType.phone,
          validator: (value) => InputValidator.phone(value, detail.label),
        );
      case AccountDetail.dateOfBirth:
        return AppDatePicker(
          label: detail.label,
          value: dateOfBirth,
          placeholder: 'Date of birth',
          required: true,
          onChanged: onDateChanged,
          formatter: DateHelper.formatDisplayDate,
        );
      case AccountDetail.gender:
        return AppRadioGroup<String>(
          label: detail.label,
          value: gender,
          required: true,
          onChanged: onGenderChanged,
          options: const [
            AppRadioOption(label: 'Male', value: 'male'),
            AppRadioOption(label: 'Female', value: 'female'),
            AppRadioOption(label: 'Others', value: 'others'),
            AppRadioOption(
              label: 'Prefer not to say',
              value: 'prefer_not_to_say',
            ),
          ],
        );
    }
  }
}

class _FullNameWarning extends StatelessWidget {
  const _FullNameWarning();

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
              shape: BoxShape.circle
            ),
            child: const Icon(Icons.warning, color: AppColors.light, size: AppFontSize.xl),
          ),
          const SizedBox(width: AppGap.xl),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'You can edit your full name again after ',
                  ),
                  const TextSpan(
                    text: '60 days',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text: ' to keep your account information secure.',
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
