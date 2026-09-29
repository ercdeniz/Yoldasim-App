// lib/modules/home/widgets/activity_update_dialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';

class ActivityUpdateDialog extends StatelessWidget {
  final ActivityModel activity;
  final int currentDailyDone;
  final int dailyTarget;
  final TargetCondition condition;

  // TODO: bu dialogun görseli ve teması düzenlenecek
  const ActivityUpdateDialog({
    super.key,
    required this.activity,
    required this.currentDailyDone,
    required this.dailyTarget,
    required this.condition,
  });

  // İlgili controller'a erişim
  ListingController get listingController => Get.find<ListingController>();

  @override
  Widget build(BuildContext context) {
    // Diyalog içindeki yerel sayaç durumunu GetX RxInt ile reactive yapıyoruz
    final counter = currentDailyDone.obs;

    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Center(
        child: Text(
          'Hedefi Güncelle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Eksi Butonu
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (counter.value > 0) counter.value--;
                    },
                    icon: const Icon(Icons.remove, color: Colors.black),
                  ),
                ),
                // Ortadaki Dev Rakam (Obx ile anlık güncellenir)
                Obx(
                  () => Text(
                    '${counter.value}',
                    style: const TextStyle(
                      fontSize: 56,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Artı Butonu
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => counter.value++,
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hedef: ${condition.getText} $dailyTarget',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Get.back(), // Navigator.pop yerine GetX kullanımı
          child: const Text(
            'Iptal',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () {
            listingController.saveActivityProgress(
              activity,
              counter.value,
              currentDailyDone,
            );
            Get.back();
          },
          child: const Text(
            'Guncelle',
            style: TextStyle(color: Colors.cyan, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
