import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/api/api_client.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_badge.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/core/widgets/app_input.dart';
import 'package:sephsuu_care/core/widgets/app_snackbar.dart';
import 'package:sephsuu_care/features/initial/existing_medications.dart';
import 'package:sephsuu_care/services/health_catalog_service.dart';
import 'package:sephsuu_care/services/user_service.dart';

class ExistingConditionsScreen extends StatefulWidget {
  const ExistingConditionsScreen({super.key});

  @override
  State<ExistingConditionsScreen> createState() =>
      _ExistingConditionsScreenState();
}

class _ExistingConditionsScreenState extends State<ExistingConditionsScreen> {
  static const _noCondition = 'No existing condition';
  static const _otherCondition = 'Other';

  final _otherConditionController = TextEditingController();
  final _catalogService = HealthCatalogService(ApiClient());
  final _userService = UserService(ApiClient());
  final Set<String> _selectedConditions = {};
  List<HealthCatalogItem> _conditions = const [];
  List<String> _conditionOptions = const [_noCondition, _otherCondition];
  bool _isLoadingOptions = true;
  bool _isSaving = false;

  bool get _isNoConditionSelected => _selectedConditions.contains(_noCondition);
  bool get _isOtherSelected => _selectedConditions.contains(_otherCondition);
  List<String> get _visibleConditionOptions =>
      _isNoConditionSelected ? const [_noCondition] : _conditionOptions;

  @override
  void initState() {
    super.initState();
    _loadConditionOptions();
  }

  @override
  void dispose() {
    _otherConditionController.dispose();
    super.dispose();
  }

  Future<void> _loadConditionOptions() async {
    try {
      final conditions = await _catalogService.getConditions();
      if (!mounted) return;

      setState(() {
        _conditions = conditions;
        _conditionOptions = [
          _noCondition,
          ...conditions.map((condition) => condition.name),
          _otherCondition,
        ];
        _isLoadingOptions = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => _isLoadingOptions = false);
      AppSnackBar.error(context, 'Unable to load condition options.');
    }
  }

  void _toggleCondition(String condition) {
    setState(() {
      if (condition == _noCondition) {
        if (_isNoConditionSelected) {
          _selectedConditions.clear();
        } else {
          _selectedConditions
            ..clear()
            ..add(condition);
          _otherConditionController.clear();
        }
        return;
      }

      _selectedConditions.remove(_noCondition);

      if (_selectedConditions.contains(condition)) {
        _selectedConditions.remove(condition);
        if (condition == _otherCondition) _otherConditionController.clear();
      } else {
        _selectedConditions.add(condition);
      }
    });
  }

  Future<void> _finish() async {
    final otherCondition = _otherConditionController.text.trim();

    if (_isOtherSelected && otherCondition.isEmpty) {
      AppSnackBar.error(context, 'Please enter your condition.');
      return;
    }
    if (_isOtherSelected) {
      AppSnackBar.error(context, 'Custom conditions are not supported yet.');
      return;
    }

    final selected = _conditions
        .where((condition) => _selectedConditions.contains(condition.name))
        .toList();

    setState(() => _isSaving = true);
    try {
      await _userService.replaceConditions(
        selected.map((condition) => condition.id),
      );
      if (!mounted) return;
      AppSnackBar.success(
        context,
        selected.isEmpty
            ? 'Existing condition step skipped.'
            : 'Existing conditions saved.',
      );
      _goToExistingMedications();
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.error(context, 'Unable to save conditions. $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _goToExistingMedications() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const ExistingMedicationsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 760;
    final horizontalPadding = isWide ? 56.0 : 22.0;
    final verticalPadding = isWide ? 36.0 : 22.0;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 760,
                      minHeight: constraints.maxHeight - (verticalPadding * 2),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _goToExistingMedications,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.gray,
                                textStyle: const TextStyle(
                                  fontSize: AppFontSize.sm,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('Skip'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const AppHeaderBadge(
                            label: 'health profile',
                            icon: Icons.health_and_safety_rounded,
                          ),
                          const SizedBox(height: 14),
                          const AppHeader1('existing conditions'),
                          const SizedBox(height: 8),
                          const Text(
                            'select  existing conditions that apply to you',
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: AppFontSize.base,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (_isLoadingOptions)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: CircularProgressIndicator(
                                  color: AppColors.pink,
                                ),
                              ),
                            )
                          else
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final condition
                                    in _visibleConditionOptions)
                                  AppBadge(
                                    label: condition,
                                    selected: _selectedConditions.contains(
                                      condition,
                                    ),
                                    onTap: () => _toggleCondition(condition),
                                  ),
                              ],
                            ),
                          if (_isOtherSelected) ...[
                            const SizedBox(height: 18),
                            AppInput(
                              label: 'Other condition',
                              controller: _otherConditionController,
                              hintText: 'Enter condition',
                              textInputAction: TextInputAction.done,
                              labelCharacter: const Icon(
                                Icons.edit_note_rounded,
                                size: AppFontSize.lg,
                                color: AppColors.pink,
                              ),
                              fillColor: AppColors.light,
                              borderColor: AppColors.lightpink,
                              focusedBorderColor: AppColors.pink,
                              borderRadius: 8,
                            ),
                          ],
                          const Spacer(),
                          const SizedBox(height: 24),
                          AppButton(
                            onProcess: _isSaving,
                            loadingLabel: const Text('saving...'),
                            width: double.infinity,
                            icon: const Icon(
                              Icons.check_circle_rounded,
                              size: 19,
                            ),
                            label: const Text(
                              'continue',
                              style: TextStyle(
                                fontSize: AppFontSize.base,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pink,
                              foregroundColor: AppColors.light,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _finish,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
