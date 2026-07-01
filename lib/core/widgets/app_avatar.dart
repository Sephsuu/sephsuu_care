import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';

// AppAvatar(
//   src: 'https://example.com/user-avatar.png',
//   alt: 'Sephsuu profile picture',
//   size: 72,
//   fallback: 'KP',
//   fallbackStyle: const TextStyle(
//     color: Colors.white,
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     letterSpacing: 0.5,
//   ),
//   backgroundColor: const Color(0xFF5A321B),
//   border: Border.all(
//     color: const Color(0xFFFFB15C),
//     width: 3,
//   ),
//   fit: BoxFit.cover,
// )

class AppAvatar extends StatelessWidget {
  final String? src;
  final String? alt;
  final double size;
  final String fallback;
  final TextStyle? fallbackStyle;
  final Color backgroundColor;
  final BoxBorder? border;
  final BoxFit fit;

  const AppAvatar({
    super.key,
    this.src,
    this.alt,
    this.size = 40,
    this.fallback = 'KP',
    this.fallbackStyle,
    this.backgroundColor = const Color(0xFF5A321B),
    this.border,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = src != null && src!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
        ? Image.network(
          src!,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallback();
          },
        )
        : _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Text(
        fallback,
        style: fallbackStyle ??
          const TextStyle(
            color: AppColors.blue,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
      ),
    );
  }
}