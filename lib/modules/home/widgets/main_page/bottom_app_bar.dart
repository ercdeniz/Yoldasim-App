import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/home/controllers/home_controller.dart';

typedef C = AppConstants;

class HomeBottomAppBar extends StatelessWidget {
  const HomeBottomAppBar({super.key});

  HomeController get mainController => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: context.cardColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.task_alt,
                  label: C.home.tasks,
                  index: 0,
                  isSelected: mainController.currentIndex.value == 0,
                  onTap: () => mainController.changePage(0),
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.bar_chart,
                  label: C.common.statistics,
                  index: 1,
                  isSelected: mainController.currentIndex.value == 1,
                  onTap: () => mainController.changePage(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.primary
        : context.text.bodyMedium?.color;

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.grey.withValues(alpha: 0.3),
      radius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
