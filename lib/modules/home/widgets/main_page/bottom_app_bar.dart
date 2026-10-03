import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/home/controllers/home_controller.dart';

typedef C = AppConstants;

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}

/// Ana sayfanın alt kısmındaki navigasyon bar widgeti.
class HomeBottomAppBar extends StatelessWidget {
  const HomeBottomAppBar({super.key});

  HomeController get mainController => Get.find();

  @override
  Widget build(BuildContext context) {
    final cornerRadius = 30.0;

    final List<_NavItem> navItems = [
      _NavItem(icon: Icons.task_alt, label: C.home.tasks),
      _NavItem(icon: Icons.bar_chart, label: C.common.statistics),
    ];

    return Obx(
      () => AnimatedBottomNavigationBar.builder(
        height: 65,
        itemCount: navItems.length,
        activeIndex: mainController.currentIndex.value,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        notchMargin: 12.0,
        leftCornerRadius: cornerRadius,
        rightCornerRadius: cornerRadius,
        backgroundColor: context.cardColor,

        scaleFactor: 0.5,

        splashColor: Colors.transparent,
        splashRadius: 0,

        onTap: (index) => mainController.changePage(index),
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? context.primary
              : context.text.bodyMedium?.color;
          final item = navItems[index];

          return AnimatedScale(
            scale: isActive ? 1.20 : 1.0,
            duration: Duration(milliseconds: C.common.animationDuration),
            curve: Curves.easeInOut,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: color, size: isActive ? 24 : 22),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  style: TextStyle(
                    color: color,
                    fontSize: isActive
                        ? context.text.labelMedium?.fontSize
                        : context.text.labelSmall?.fontSize,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
