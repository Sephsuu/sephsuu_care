import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';

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
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF8FB3), Color(0xFF8EC5FF), Color(0xFF7EE8C8)],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/sefi.png',
                  width: MediaQuery.sizeOf(context).width * 0.72,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),
                AppButton(
                  width: double.infinity,
                  height: 52,
                  label: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.light,
                    disabledBackgroundColor: AppColors.blue.withValues(
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
                  onPressed: () {},
                ),
                const SizedBox(height: 14),
                AppButton(
                  width: double.infinity,
                  height: 52,
                  label: const Text(
                    "Don't have an account? Signup",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
                  onPressed: () {},
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
