import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_badge.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.menu_book_rounded, label: 'Learn'),
    (icon: Icons.medical_services_outlined, label: 'Vitals'),
    (icon: Icons.person_outline_rounded, label: 'Chat'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(18, 10, 18, 16),
      child: AppCard(
        height: 64,
        padding: const EdgeInsets.all(8),
        backgroundColor: AppColors.card,
        borderColor: AppColors.lightpink,
        borderRadius: 28,
        boxShadow: AppClay.shadows,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final unitWidth = constraints.maxWidth / 9;

            return Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = selectedIndex == index;

                return AnimatedContainer(
                  width: unitWidth * (isSelected ? 3 : 2),
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: item.label,
                    child: AppBadge(
                      label: item.label,
                      selected: isSelected,
                      onTap: () => onSelected(index),
                      icon: item.icon,
                      selectedIcon: item.icon,
                      showLabel: isSelected,
                      mainAxisAlignment: MainAxisAlignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      borderRadius: 20,
                      gap: 8,
                      iconSize: 25,
                      selectedBackgroundColor: AppColors.pink,
                      backgroundColor: AppColors.card,
                      borderColor: AppColors.card,
                      selectedBorderColor: null,
                      selectedForegroundColor: AppColors.light,
                      foregroundColor: AppColors.gray,
                      selectedBoxShadow: [
                        BoxShadow(
                          color: AppColors.pink.withValues(alpha: 0.24),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      animationDuration: const Duration(milliseconds: 280),
                      textStyle: const TextStyle(
                        color: AppColors.light,
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
