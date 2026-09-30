import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/activity_stat_chip.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/activity_update_dialog.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/base_list_card.dart';

class ActivityRouter extends StatelessWidget {
  final ActivityModel activity;

  const ActivityRouter({super.key, required this.activity});

  ListingController get listingController => Get.find<ListingController>();
  CalendarController get calendarController => Get.find<CalendarController>();

  /// Aktivite tipine göre uygun liste elemanını döndürür.
  /// [_salahActivityItem] : Namaz aktiviteleri için liste elemanı.
  /// [_fastingActivityItem] : Oruç aktiviteleri için liste elemanı.
  /// [_dhikrActivityItem] : Zikir aktiviteleri için liste elemanı.
  /// [_quranActivityItem] : Kur'an aktiviteleri için liste elemanı.
  @override
  Widget build(BuildContext context) {
    switch (activity.type) {
      case ActivityType.salah:
        return _salahActivityItem(context, activity: activity);
      case ActivityType.fasting:
        return _fastingActivityItem(activity: activity);
      case ActivityType.dhikr:
        return _dhikrActivityItem(activity: activity);
      case ActivityType.quran:
        return _quranActivityItem(activity: activity);
    }
  }

  /// Namaz aktiviteleri için liste elemanı.
  /// [dailyDone] : Günlük tamamlanan sayısı. [ListingController] içindeki [dailyDoneCounts] map'inden alınır.
  /// [dailyTarget] : Günlük hedef sayısı. ActivityModel içindeki [SalahDetails]'dan alınır.
  /// [totalDone] : Toplam tamamlanan sayısı. ActivityModel içindeki [SalahDetails]'dan alınır.
  /// [totalDebt] : Toplam borç sayısı. ActivityModel içindeki [SalahDetails]'dan alınır.
  /// [condition] : Hedef koşulu. ActivityModel içindeki [SalahDetails]'dan alınır.
  /// [completed] : Aktivitenin tamamlanma durumu. [ListingController] içindeki [calculateCompletionStatus] fonksiyonu ile hesaplanır.
  /// [onTap] : Liste elemanına tıklandığında açılacak olan [ActivityUpdateDialog] dialogunu gönderen Callback fonksiyonudur.
  /// [completed] değeri controller'daki [calculateCompletionStatus] fonksiyonu ile belirlenir.
  Widget _salahActivityItem(
    BuildContext context, {
    required ActivityModel activity,
  }) {
    final details = activity.salahDetails!;
    final int dailyDone = listingController.dailyDoneCounts[activity.id] ?? 0;
    final int dailyTarget = details.dailyTarget;
    final int totalDone = details.totalDone;
    final int totalDebt = details.totalDebt;
    final TargetCondition condition = details.targetCondition;
    final Color color = ActivityType.salah.color;

    final ActivityStatus completed = listingController
        .calculateCompletionStatus(
          dailyDone: dailyDone,
          dailyTarget: dailyTarget,
          condition: condition,
          selectedDate: calendarController.selectedDate.value,
          isDailyMandatory: activity.isDailyMandatory,
        );


    return BaseActivityCard(
      activity: activity,
      iconPath: ActivityType.salah.iconPath,
      color: color,
      status: completed,
      chips: [
        ActivityStatChip(value: '$dailyDone/$dailyTarget', color: color),
        ActivityStatChip(value: '$totalDone/$totalDebt', color: color),
      ],
      onTap: () {
        Get.dialog(
          ActivityUpdateDialog(
            activity: activity,
            currentDailyDone: dailyDone,
            dailyTarget: dailyTarget,
            condition: condition,
          ),
        );
      },
    );
  }

  Widget _fastingActivityItem({required ActivityModel activity}) {
    return SizedBox.shrink(); // TODO: Implement fasting activity item
  }

  Widget _dhikrActivityItem({required ActivityModel activity}) {
    return SizedBox.shrink(); // TODO: Implement dhikr activity item
  }

  Widget _quranActivityItem({required ActivityModel activity}) {
    return SizedBox.shrink(); // TODO: Implement quran activity item
  }
}
