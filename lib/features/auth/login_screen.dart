import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_input.dart';
import 'package:sephsuu_care/features/dashboard/user_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isSigningIn = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSigningIn = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSigningIn = false);

    final identifier = _identifierController.text.trim();
    final username = identifier.contains('@')
        ? identifier.split('@').first
        : identifier;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => UserDashboardScreen(username: username),
      ),
      (route) => false,
    );
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordHidden = !_isPasswordHidden);
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
            colors: [Color(0xFFFFEEF3), Color(0xFFF7FBFF), Color(0xFFE7F8EF)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const _SoftCircle(
                top: -76,
                right: -54,
                size: 190,
                color: Color(0x40FF6A7F),
              ),
              const _SoftCircle(
                left: -74,
                bottom: 108,
                size: 168,
                color: Color(0x3327AE60),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 56 : 22,
                  vertical: isWide ? 36 : 22,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: isWide
                        ? Row(
                            children: [
                              const Expanded(child: _LoginArt()),
                              const SizedBox(width: 42),
                              Expanded(child: _LoginPanel(screen: this)),
                            ],
                          )
                        : Column(
                            children: [
                              const _LoginArt(compact: true),
                              const SizedBox(height: 16),
                              _LoginPanel(screen: this),
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

class _LoginArt extends StatelessWidget {
  final bool compact;

  const _LoginArt({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton.filledTonal(
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        // SizedBox(height: compact ? 10 : 34),
        Container(
          width: compact ? 235 : 390,
          height: compact ? 235 : 420,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.light.withValues(alpha: 0.62),
            border: Border.all(color: AppColors.light, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withValues(alpha: 0.16),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/login_sefi.png',
            width: compact ? 224 : 370,
            fit: BoxFit.contain,
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 28),
          Text(
            'a calmer way back in',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.dark,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your care space is ready when you are.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.gray,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _LoginPanel extends StatelessWidget {
  final _LoginScreenState screen;

  const _LoginPanel({required this.screen});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: 8,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      backgroundColor: AppColors.light.withValues(alpha: 0.88),
      borderColor: AppColors.light,
      boxShadow: [
        BoxShadow(
          color: AppColors.dark.withValues(alpha: 0.08),
          blurRadius: 28,
          offset: const Offset(0, 16),
        ),
      ],
      child: Form(
        key: screen._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppHeader1('login to sephsuu care'),
            const SizedBox(height: 26),
            AppInput(
              controller: screen._identifierController,
              label: 'Email or username',
              hintText: 'sefi@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              fillColor: AppColors.light,
              borderColor: AppColors.lightpink,
              focusedBorderColor: AppColors.pink,
              borderRadius: 8,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email or username is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppInput(
              controller: screen._passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: screen._isPasswordHidden,
              textInputAction: TextInputAction.done,
              fillColor: AppColors.light,
              borderColor: AppColors.lightpink,
              focusedBorderColor: AppColors.pink,
              borderRadius: 8,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: TextButton.icon(
                  onPressed: screen._togglePasswordVisibility,
                  icon: Icon(
                    screen._isPasswordHidden
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 18,
                  ),
                  label: Text(screen._isPasswordHidden ? 'Show' : 'Hide'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.dark,
                    minimumSize: const Size(0, 42),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) return 'Use at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 22),
            AppButton(
              width: double.infinity,
              onProcess: screen._isSigningIn,
              loadingLabel: const Text(
                'opening care space...',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              label: const Text(
                'login',
                style: TextStyle(
                  fontSize: AppFontSize.base,
                  fontWeight: FontWeight.w900,
                ),
              ),
              icon: const Icon(Icons.favorite_rounded, size: 19),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.light,
                disabledBackgroundColor: AppColors.pink.withValues(alpha: 0.6),
                disabledForegroundColor: AppColors.light.withValues(alpha: 0.8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: screen._handleLogin,
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double size;
  final Color color;

  const _SoftCircle({
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
