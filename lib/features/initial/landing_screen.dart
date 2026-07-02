import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/features/auth/login_screen.dart';
import 'package:sephsuu_care/features/auth/role_selection_screen.dart';
import 'package:sephsuu_care/helpers/widgets/arced_text.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE3EB), Color(0xFFF5FAFF), Color(0xFFE3F6EF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              children: [
                const Spacer(),
                const _LandingHeader(),
                const SizedBox(height: 24),
                Image.asset(
                  'assets/images/sefi.png',
                  width: MediaQuery.sizeOf(context).width * 0.72,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),
                AppButton(
                  width: double.infinity,
                  label: const Text(
                    'Login',
                    style: TextStyle(fontSize: AppFontSize.base, fontWeight: FontWeight.w700),
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                AppButton(
                  width: double.infinity,
                  label: const Text(
                    "Don't have an account? Signup",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppFontSize.base, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.light,
                    foregroundColor: AppColors.dark,
                    disabledBackgroundColor: AppColors.light.withValues(
                      alpha: 0.7,
                    ),
                    disabledForegroundColor: AppColors.dark.withValues(
                      alpha: 0.5,
                    ),
                    elevation: 0,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const RoleSelectionScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LandingHeader extends StatelessWidget {
  const _LandingHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.light.withValues(alpha: 0.74),
            border: Border.all(color: AppColors.light),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AppColors.pink,
                size: 18,
              ),
              const SizedBox(width: 7),
              Text(
                'gentle care companion',
                style: GoogleFonts.inter(
                  color: AppColors.dark,
                  fontSize: AppFontSize.xs,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ArcedText(
          text: 'sephsuu care',
          width: 50,
          height: 82,
          radius: 360,
          letterSpacing: 7,
          arcDegrees: 5,
          style: GoogleFonts.inter(
            color: AppColors.dark,
            fontSize: AppFontSize.x3l,
            fontWeight: FontWeight.w900,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -12),
          child: Column(
            children: [
              Container(
                width: 74,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.inter(
                    color: AppColors.gray,
                    fontSize: AppFontSize.base,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    const TextSpan(text: 'your health, '),
                    TextSpan(
                      text: 'cared for',
                      style: GoogleFonts.inter(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(text: '\nanytime.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
