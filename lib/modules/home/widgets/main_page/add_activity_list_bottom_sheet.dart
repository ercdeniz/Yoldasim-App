import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/routes/app_routes.dart';

typedef C = AppConstants;

/// Aktivite ekleme alt sayfası. (bottom sheet)
/// Bu widget, kullanıcıya hangi aktiviteyi eklemek istediğini seçmesi için bir alt sayfa (bottom sheet) sunar.
class AddActivityBottomSheet extends StatelessWidget {
  const AddActivityBottomSheet({super.key});

  static void show() {
    Get.bottomSheet(const AddActivityBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text(C.activity.activityAddTitle, style: context.text.titleLarge),
              const SizedBox(height: 16),

              // SEÇENEKLER
              // Namaz kazası
              _buildActivityOption(
                context: context,
                iconPath: ActivityType.salah.iconPath,
                color: ActivityType.salah.color,
                title: C.activity.salahTitle,
                subtitle: C.activity.salahDesc,
                onTapRoute: AppRoutes.SALAH,
              ),

              // Oruç kazası
              _buildActivityOption(
                context: context,
                iconPath: ActivityType.fasting.iconPath,
                color: ActivityType.fasting.color,
                title: C.activity.fastingTitle,
                subtitle: C.activity.fastingDesc,
                onTapRoute: AppRoutes.FASTING,
              ),

              // Kuran
              _buildActivityOption(
                context: context,
                iconPath: ActivityType.quran.iconPath,
                color: ActivityType.quran.color,
                title: C.activity.quranTitle,
                subtitle: C.activity.quranDesc,
                onTapRoute: AppRoutes.QURAN,
              ),

              // Zikir
              _buildActivityOption(
                context: context,
                iconPath: ActivityType.dhikr.iconPath,
                color: ActivityType.dhikr.color,
                title: C.activity.dhikrTitle,
                subtitle: C.activity.dhikrDesc,
                onTapRoute: AppRoutes.DHIKR,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildActivityOption({
    required BuildContext context,
    required String iconPath,
    required Color color,
    required String title,
    required String subtitle,
    required String onTapRoute,
    double iconSize = 44.0,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        radius: 24,
        child: SvgPicture.asset(
          iconPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      onTap: () => Get.offNamed(onTapRoute),
    );
  }
}
