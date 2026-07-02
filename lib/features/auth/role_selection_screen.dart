import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/features/auth/registration_form_screen.dart';

enum SignupRole { patient, nurse, doctor }

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  SignupRole? _selectedRole;

  final List<_RoleOption> _roles = const [
    _RoleOption(
      role: SignupRole.patient,
      label: 'patient',
      // description: 'Track care, appointments, and everyday wellness.',
      assetPath: 'assets/images/sefi_patient.png',
      color: AppColors.pink,
      softColor: Color(0xFFFFEEF3),
      icon: Icons.favorite_border_rounded,
    ),
    _RoleOption(
      role: SignupRole.nurse,
      label: 'nurse',
      assetPath: 'assets/images/sefi_nurse.png',
      color: AppColors.mint,
      softColor: Color(0xFFE9F8F0),
      icon: Icons.local_hospital_outlined,
    ),
    _RoleOption(
      role: SignupRole.doctor,
      label: 'doctor',
      assetPath: 'assets/images/sefi_doctor.png',
      color: AppColors.blue,
      softColor: Color(0xFFEAF3FF),
      icon: Icons.medical_services_outlined,
    ),
  ];

  void _continueSignup() {
    final selectedRole = _selectedRole;
    if (selectedRole == null) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RegistrationFormScreen(role: selectedRole.name),
      ),
    );
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
          child: Stack(
            children: [
              const _AccentDot(
                top: -70,
                right: -50,
                size: 190,
                color: Color(0x33FF6A7F),
              ),
              const _AccentDot(
                bottom: 90,
                left: -72,
                size: 170,
                color: Color(0x3027AE60),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 56 : 22,
                  vertical: isWide ? 36 : 22,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1060),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Back',
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(height: 20),
                        _RoleHeader(isWide: isWide),
                        const SizedBox(height: 28),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final useGrid = constraints.maxWidth >= 760;

                            if (useGrid) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final role in _roles) ...[
                                    Expanded(
                                      child: _RoleCard(
                                        option: role,
                                        selected: _selectedRole == role.role,
                                        onTap: () {
                                          setState(() {
                                            _selectedRole = role.role;
                                          });
                                        },
                                      ),
                                    ),
                                    if (role != _roles.last)
                                      const SizedBox(width: 16),
                                  ],
                                ],
                              );
                            }

                            return Column(
                              children: [
                                for (final role in _roles) ...[
                                  _RoleCard(
                                    option: role,
                                    selected: _selectedRole == role.role,
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = role.role;
                                      });
                                    },
                                  ),
                                  if (role != _roles.last)
                                    const SizedBox(height: 14),
                                ],
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          width: double.infinity,
                          height: 54,
                          disabled: _selectedRole == null,
                          icon: const Icon(Icons.login_rounded, size: 19),
                          label: const Text(
                            'continue signup',
                            style: TextStyle(
                              fontSize: AppFontSize.base,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _continueSignup,
                        ),
                      ],
                    ),
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

class _RoleHeader extends StatelessWidget {
  final bool isWide;

  const _RoleHeader({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: isWide ? 3 : 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.light.withValues(alpha: 0.76),
                  border: Border.all(color: AppColors.light),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'choose your care path',
                  style: GoogleFonts.inter(
                    color: AppColors.pink,
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'who are you signing up as?',
                style: GoogleFonts.inter(
                  color: AppColors.dark,
                  fontSize: AppFontSize.x3l,
                  height: 1.03,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final _RoleOption option;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: selected ? 1.02 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: BoxDecoration(
            color: AppColors.light.withValues(alpha: selected ? 0.96 : 0.78),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.pink : AppColors.light,
              width: selected ? 3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withValues(alpha: selected ? 0.2 : 0.09),
                blurRadius: selected ? 28 : 18,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.pink : AppColors.light,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.pink, width: 1.5),
                    ),
                    child: Icon(
                      option.icon,
                      color: selected ? AppColors.light : AppColors.pink,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    option.label,
                    style: GoogleFonts.inter(
                      color: AppColors.dark,
                      fontSize: AppFontSize.xl,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Center(
                child: Container(
                  height: 190,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: AppColors.lightpink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    option.assetPath,
                    height: 180,
                    fit: BoxFit.contain,
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

class _RoleOption {
  final SignupRole role;
  final String label;
  final String assetPath;
  final Color color;
  final Color softColor;
  final IconData icon;

  const _RoleOption({
    required this.role,
    required this.label,
    required this.assetPath,
    required this.color,
    required this.softColor,
    required this.icon,
  });
}

class _AccentDot extends StatelessWidget {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double size;
  final Color color;

  const _AccentDot({
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
