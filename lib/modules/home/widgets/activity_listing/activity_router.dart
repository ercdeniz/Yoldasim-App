import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/sting_extention.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/services/activity_schedule_service.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/activity_stat_chip.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/base_list_card.dart';
import 'package:yoldasim_app/widgets/dialogs/activity_detail_dialog.dart';
import 'package:yoldasim_app/widgets/dialogs/binary_update_dialog.dart';
import 'package:yoldasim_app/widgets/dialogs/counter_update_dialog.dart';

typedef C = AppConstants;

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
    return Obx(() {
      switch (activity.type) {
        case ActivityType.salah:
          return _salahActivityItem(context, activity: activity);
        case ActivityType.fasting:
          return _fastingActivityItem(context, activity: activity);
        case ActivityType.dhikr:
          return _dhikrActivityItem(context, activity: activity);
        case ActivityType.quran:
          return _quranActivityItem(context, activity: activity);
      }
    });
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
    final int totalDone = activity.totalDone;
    final int totalDebt = details.totalDebt;
    final TargetCondition condition = details.targetCondition;
    final Color color = ActivityType.salah.color;

    final ActivityStatus completed = listingController
        .calculateCompletionStatus(
          dailyDone: dailyDone,
          dailyTarget: dailyTarget,
          condition: condition,
          selectedDate: calendarController.selectedDate.value,
          isMandatory: activity.isMandatory,
        );

    void onTapUpdate() {
      Get.dialog(
        CounterUpdateDialog(
          currentValue: dailyDone,
          target: dailyTarget,
          condition: condition,
          onSave: (value) => listingController.saveActivityProgress(
            activity,
            value,
            dailyDone,
          ),
        ),
      );
    }

    return BaseActivityCard(
      activity: activity,
      iconPath: ActivityType.salah.iconPath,
      color: color,
      status: completed,
      chips: [
        ActivityStatChip(value: '$dailyDone/$dailyTarget', color: color),
        ActivityStatChip(value: '$totalDone/$totalDebt', color: color),
      ],
      onCardTap: () => Get.dialog(
        ActivityDetailDialog(activity: activity, onTapUpdate: onTapUpdate),
      ),
      onProgressTap: onTapUpdate,
    );
  }

  Widget _fastingActivityItem(
    BuildContext context, {
    required ActivityModel activity,
  }) {
    final details = activity.fastingDetails!;
    final int dailyDone = listingController.dailyDoneCounts[activity.id] ?? 0;
    final color = ActivityType.fasting.color;
    final status = listingController.calculateCompletionStatus(
      dailyDone: dailyDone,
      dailyTarget: 1,
      condition: TargetCondition.atLeast,
      selectedDate: calendarController.selectedDate.value,
      isMandatory: activity.isMandatory,
    );

    void onTapUpdate() {
      Get.dialog(
        BinaryUpdateDialog(
          question: C.activity.fastingQuestion,
          positiveLabel: C.common.yes,
          negativeLabel: C.common.no,
          errorMessagePrefix: C.activity.updateErrorBase,
          onSave: (value) => listingController.saveActivityProgress(
            activity,
            value ? 1 : 0,
            dailyDone,
          ),
        ),
      );
    }

    return BaseActivityCard(
      activity: activity,
      iconPath: ActivityType.fasting.iconPath,
      color: color,
      status: status,
      chips: [
        ActivityStatChip(
          value: '${activity.totalDone}/${details.totalDebt}',
          color: color,
        ),
      ],
      onCardTap: () => Get.dialog(
        ActivityDetailDialog(activity: activity, onTapUpdate: onTapUpdate),
      ),
      onProgressTap: onTapUpdate,
    );
  }

  Widget _dhikrActivityItem(
    BuildContext context, {
    required ActivityModel activity,
  }) {
    final details = activity.dhikrDetails!;
    final int dailyDone = listingController.dailyDoneCounts[activity.id] ?? 0;
    final int periodDone = listingController.periodDoneCounts[activity.id] ?? 0;
    final color = ActivityType.dhikr.color;
    final periodRange = ActivityScheduleService.periodRange(
      activity.period,
      calendarController.selectedDate.value,
    );
    final status = listingController.calculatePeriodCompletionStatus(
      periodDone: periodDone,
      periodTarget: details.targetCount,
      condition: activity.targetCondition,
      selectedDate: calendarController.selectedDate.value,
      periodEnd: periodRange.end,
      isMandatory: activity.isMandatory,
      isOpenEnded: activity.period == ActivityPeriod.allTime,
    );

    void onTapUpdate() {
      Get.dialog(
        CounterUpdateDialog(
          currentValue: dailyDone,
          target: details.targetCount,
          condition: activity.targetCondition,
          onSave: (value) => listingController.saveActivityProgress(
            activity,
            value,
            dailyDone,
          ),
        ),
      );
    }

    return BaseActivityCard(
      activity: activity,
      iconPath: ActivityType.dhikr.iconPath,
      color: color,
      status: status,
      chips: [
        ActivityStatChip(
          value: '$periodDone/${details.targetCount}',
          color: color,
        ),
        ActivityStatChip(value: details.arabicText.truncate(20), color: color),
      ],
      onCardTap: () => Get.dialog(
        ActivityDetailDialog(activity: activity, onTapUpdate: onTapUpdate),
      ),
      onProgressTap: onTapUpdate,
    );
  }

  Widget _quranActivityItem(
    BuildContext context, {
    required ActivityModel activity,
  }) {
    final details = activity.quranDetails!;
    final int dailyDone = listingController.dailyDoneCounts[activity.id] ?? 0;
    final int periodDone = listingController.periodDoneCounts[activity.id] ?? 0;
    final color = ActivityType.quran.color;
    final periodRange = ActivityScheduleService.periodRange(
      activity.period,
      calendarController.selectedDate.value,
    );
    final status = listingController.calculatePeriodCompletionStatus(
      periodDone: periodDone,
      periodTarget: details.targetValue,
      condition: activity.targetCondition,
      selectedDate: calendarController.selectedDate.value,
      periodEnd: periodRange.end,
      isMandatory: activity.isMandatory,
      isOpenEnded: activity.period == ActivityPeriod.allTime,
    );

    final displayName = details.targetType == QuranTargetType.surah
        ? C.activity.quranSurahNames[details.selectedSurahNumber - 1]
        : details.targetType.displayName;

    void onTapUpdate() {
      Get.dialog(
        CounterUpdateDialog(
          currentValue: dailyDone,
          target: details.targetValue,
          condition: activity.targetCondition,
          onSave: (value) => listingController.saveActivityProgress(
            activity,
            value,
            dailyDone,
          ),
        ),
      );
    }

    return BaseActivityCard(
      activity: activity,
      iconPath: ActivityType.quran.iconPath,
      color: color,
      status: status,
      chips: [
        ActivityStatChip(
          value: '$periodDone/${details.targetValue}',
          color: color,
        ),
        ActivityStatChip(value: displayName, color: color),
        if (details.targetType == QuranTargetType.juz)
          ActivityStatChip(
            value: details.selectedJuzNumbers.join(', '),
            color: color,
          ),
      ],
      onCardTap: () => Get.dialog(
        ActivityDetailDialog(activity: activity, onTapUpdate: onTapUpdate),
      ),
      onProgressTap: onTapUpdate,
    );
  }
}
