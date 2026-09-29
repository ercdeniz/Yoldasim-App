import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/routes/app_routes.dart';

typedef C = AppConstants;

/// Aktivite ekleme alt sayfası.
/// Bu widget, kullanıcıya hangi aktiviteyi eklemek istediğini seçmesi için bir alt sayfa (bottom sheet) sunar.
class AddActivityBottomSheet extends StatelessWidget {
  const AddActivityBottomSheet({super.key});

  static void show() {
    Get.bottomSheet(
      const AddActivityBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.scaffoldBackgroundColor,
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
              Text(
                C.activity.activityAddTitle,
                style: context.theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // SEÇENEKLER
              // Namaz kazası
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.mosque, color: Colors.white),
                ),
                title: Text(C.activity.salahTitle),
                subtitle: Text(C.activity.salahDesc),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.SALAH);
                },
              ),

              // Oruç kazası
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.wb_sunny, color: Colors.white),
                ),
                title: Text(C.activity.fastingTitle),
                subtitle: Text(C.activity.fastingDesc),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.FASTING);
                },
              ),

              // Kur'an hedefi
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.menu_book, color: Colors.white),
                ),
                title: Text(C.activity.quranTitle),
                subtitle: Text(C.activity.quranDesc),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.QURAN);
                },
              ),

              // Zikir / Tesbihat
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.purpleAccent,
                  child: Icon(Icons.fingerprint, color: Colors.white),
                ),
                title: Text(C.activity.dhikrTitle),
                subtitle: Text(C.activity.dhikrDesc),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.DHIKR);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
