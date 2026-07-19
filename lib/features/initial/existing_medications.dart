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
import 'package:sephsuu_care/features/dashboard/user_dashboard_screen.dart';
import 'package:sephsuu_care/services/health_catalog_service.dart';
import 'package:sephsuu_care/services/user_service.dart';

class ExistingMedicationsScreen extends StatefulWidget {
  const ExistingMedicationsScreen({super.key});

  @override
  State<ExistingMedicationsScreen> createState() =>
      _ExistingMedicationsScreenState();
}

class _ExistingMedicationsScreenState extends State<ExistingMedicationsScreen> {
  static const _noMedication = 'No current medication';
  static const _otherMedication = 'Other';

  final _otherMedicationController = TextEditingController();
  final _catalogService = HealthCatalogService(ApiClient());
  final _userService = UserService(ApiClient());
  final Set<String> _selectedMedications = {};
  List<HealthCatalogItem> _medications = const [];
  List<String> _medicationOptions = const [_noMedication, _otherMedication];
  bool _isLoadingOptions = true;
  bool _isSaving = false;

  bool get _isNoMedicationSelected =>
      _selectedMedications.contains(_noMedication);
  bool get _isOtherSelected => _selectedMedications.contains(_otherMedication);
  List<String> get _visibleMedicationOptions =>
      _isNoMedicationSelected ? const [_noMedication] : _medicationOptions;

  @override
  void initState() {
    super.initState();
    _loadMedicationOptions();
  }

  @override
  void dispose() {
    _otherMedicationController.dispose();
    super.dispose();
  }

  Future<void> _loadMedicationOptions() async {
    try {
      final medications = await _catalogService.getMedications();
      if (!mounted) return;

      setState(() {
        _medications = medications;
        _medicationOptions = [
          _noMedication,
          ...medications.map((medication) => medication.name),
          _otherMedication,
        ];
        _isLoadingOptions = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => _isLoadingOptions = false);
      AppSnackBar.error(context, 'Unable to load medication options.');
    }
  }

  void _toggleMedication(String medication) {
    setState(() {
      if (medication == _noMedication) {
        if (_isNoMedicationSelected) {
          _selectedMedications.clear();
        } else {
          _selectedMedications
            ..clear()
            ..add(medication);
          _otherMedicationController.clear();
        }
        return;
      }

      _selectedMedications.remove(_noMedication);

      if (_selectedMedications.contains(medication)) {
        _selectedMedications.remove(medication);
        if (medication == _otherMedication) _otherMedicationController.clear();
      } else {
        _selectedMedications.add(medication);
      }
    });
  }

  Future<void> _finish() async {
    final otherMedication = _otherMedicationController.text.trim();

    if (_isOtherSelected && otherMedication.isEmpty) {
      AppSnackBar.error(context, 'Please enter your medication.');
      return;
    }
    if (_isOtherSelected) {
      AppSnackBar.error(context, 'Custom medications are not supported yet.');
      return;
    }

    final selected = _medications
        .where((medication) => _selectedMedications.contains(medication.name))
        .toList();

    setState(() => _isSaving = true);
    try {
      await _userService.replaceMedications(
        selected.map((medication) => medication.id),
      );
      if (!mounted) return;
      AppSnackBar.success(
        context,
        selected.isEmpty
            ? 'Medication step skipped.'
            : 'Current medications saved.',
      );
      _goHome();
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.error(context, 'Unable to save medications. $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => const UserDashboardScreen(),
      ),
      (route) => false,
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
                              onPressed: _goHome,
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
                            icon: Icons.medication_rounded,
                          ),
                          const SizedBox(height: 14),
                          const AppHeader1('current medications'),
                          const SizedBox(height: 8),
                          const Text(
                            'select medications you are currently taking',
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
                                for (final medication
                                    in _visibleMedicationOptions)
                                  AppBadge(
                                    label: medication,
                                    selected: _selectedMedications.contains(
                                      medication,
                                    ),
                                    onTap: () => _toggleMedication(medication),
                                  ),
                              ],
                            ),
                          if (_isOtherSelected) ...[
                            const SizedBox(height: 18),
                            AppInput(
                              label: 'Other medication',
                              controller: _otherMedicationController,
                              hintText: 'Enter medication',
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
