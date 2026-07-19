import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';

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
    (icon: Icons.favorite_border_rounded, label: 'Learn'),
    (icon: Icons.medical_services_outlined, label: 'Vitals'),
    (icon: Icons.person_outline_rounded, label: 'Chat'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(18, 8, 18, 14),
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark.withValues(alpha: 0.08),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = selectedIndex == index;

            return Expanded(
              flex: isSelected ? 2 : 1,
              child: Semantics(
                button: true,
                selected: isSelected,
                label: item.label,
                child: InkWell(
                  onTap: () => onSelected(index),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.dark : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? Colors.white : AppColors.dark,
                          size: 25,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
