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
import 'package:sephsuu_care/features/initial/existing_conditions_screen.dart';
import 'package:sephsuu_care/services/health_catalog_service.dart';
import 'package:sephsuu_care/services/user_service.dart';

class KnownAllergiesScreen extends StatefulWidget {
  const KnownAllergiesScreen({super.key});

  @override
  State<KnownAllergiesScreen> createState() => _KnownAllergiesScreenState();
}

class _KnownAllergiesScreenState extends State<KnownAllergiesScreen> {
  static const _noAllergy = 'No known allergy';
  static const _otherAllergy = 'Others';

  final _otherAllergyController = TextEditingController();
  final _catalogService = HealthCatalogService(ApiClient());
  final _userService = UserService(ApiClient());
  final Set<String> _selectedAllergies = {};
  List<HealthCatalogItem> _allergies = const [];
  List<String> _allergyOptions = const [_noAllergy, _otherAllergy];
  bool _isLoadingOptions = true;
  bool _isSaving = false;

  bool get _isNoAllergySelected => _selectedAllergies.contains(_noAllergy);
  bool get _isOtherSelected => _selectedAllergies.contains(_otherAllergy);
  List<String> get _visibleAllergyOptions =>
      _isNoAllergySelected ? const [_noAllergy] : _allergyOptions;

  @override
  void initState() {
    super.initState();
    _loadAllergyOptions();
  }

  @override
  void dispose() {
    _otherAllergyController.dispose();
    super.dispose();
  }

  Future<void> _loadAllergyOptions() async {
    try {
      final allergies = await _catalogService.getAllergies();
      if (!mounted) return;

      setState(() {
        _allergies = allergies;
        _allergyOptions = [
          _noAllergy,
          ...allergies.map((allergy) => allergy.name),
          _otherAllergy,
        ];
        _isLoadingOptions = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => _isLoadingOptions = false);
      AppSnackBar.error(context, 'Unable to load allergy options.');
    }
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (allergy == _noAllergy) {
        if (_isNoAllergySelected) {
          _selectedAllergies.clear();
        } else {
          _selectedAllergies
            ..clear()
            ..add(allergy);
          _otherAllergyController.clear();
        }
        return;
      }

      _selectedAllergies.remove(_noAllergy);

      if (_selectedAllergies.contains(allergy)) {
        _selectedAllergies.remove(allergy);
        if (allergy == _otherAllergy) _otherAllergyController.clear();
      } else {
        _selectedAllergies.add(allergy);
      }
    });
  }

  Future<void> _finish() async {
    final otherAllergy = _otherAllergyController.text.trim();

    if (_isOtherSelected && otherAllergy.isEmpty) {
      AppSnackBar.error(context, 'Please enter your allergy.');
      return;
    }
    if (_isOtherSelected) {
      AppSnackBar.error(context, 'Custom allergies are not supported yet.');
      return;
    }

    final selected = _allergies
        .where((allergy) => _selectedAllergies.contains(allergy.name))
        .toList();

    setState(() => _isSaving = true);
    try {
      await _userService.replaceAllergies(
        selected.map((allergy) => allergy.id),
      );
      if (!mounted) return;
      AppSnackBar.success(
        context,
        selected.isEmpty ? 'Allergy step skipped.' : 'Allergies saved.',
      );
      _goToExistingConditions();
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.error(context, 'Unable to save allergies. $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _goToExistingConditions() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const ExistingConditionsScreen(),
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
                              onPressed: _goToExistingConditions,
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
                            icon: Icons.medical_information_rounded,
                          ),
                          const SizedBox(height: 14),
                          const AppHeader1('known allergies'),
                          const SizedBox(height: 8),
                          const Text(
                            'select one or more allergies you already know about yourself',
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
                                for (final allergy in _visibleAllergyOptions)
                                  AppBadge(
                                    label: allergy,
                                    selected: _selectedAllergies.contains(
                                      allergy,
                                    ),
                                    onTap: () => _toggleAllergy(allergy),
                                  ),
                              ],
                            ),
                          if (_isOtherSelected) ...[
                            const SizedBox(height: 18),
                            AppInput(
                              label: 'Other allergy',
                              controller: _otherAllergyController,
                              hintText: 'Enter allergy',
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
