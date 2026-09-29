import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/modules/home/controllers/controller.dart';

typedef C = AppConstants;

class ListActivities extends GetView<HomeController> {
  const ListActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final targetDate = DateFormat('yyyy-MM-dd')
            .format(controller.selectedDate.value);
        final filteredActivities = controller.activities.where((activity) {
          final activityDate = DateFormat('yyyy-MM-dd')
              .format(activity.startDate);
          return targetDate.compareTo(activityDate) >= 0;
        }).toList();

        if (filteredActivities.isEmpty) {
          return Center(
            child: Text(
              C.home.noActivity,
              style: TextStyle(
                fontSize: context.theme.textTheme.titleMedium?.fontSize,
                color: context.theme.textTheme.bodyMedium?.color,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: filteredActivities.length,
          itemBuilder: (context, index) {
            final activity = filteredActivities[index];
            return activityItemRouter(context, activity: activity);
          },
        );
      }),
    );
  }

/// Aktivite tipine göre uygun liste elemanını döndürür.
/// [salahActivityItem] : Namaz aktiviteleri için liste elemanı.
/// [fastingActivityItem] : Oruç aktiviteleri için liste elemanı.
/// [dhikrActivityItem] : Zikir aktiviteleri için liste elemanı.
/// [quranActivityItem] : Kur'an aktiviteleri için liste elemanı.
  Widget activityItemRouter(
    BuildContext context, {
    required ActivityModel activity,
  }) {
    switch (activity.type) {
      case ActivityType.salah:
        return salahActivityItem(context, activity: activity);
      case ActivityType.fasting:
        return fastingActivityItem(activity: activity);
      case ActivityType.dhikr:
        return dhikrActivityItem(activity: activity);
      case ActivityType.quran:
        return quranActivityItem(activity: activity);
    }
  }

  Widget salahActivityItem(
    BuildContext context, {
    required ActivityModel activity,
  }) {
    final details = activity.salahDetails!;
    final int dailyDone = controller.dailyDoneCounts[activity.id] ?? 0;
    final int dailyTarget = details.dailyTarget;
    final int totalDone = details.totalDone;
    final int totalDebt = details.totalDebt;
    final TargetCondition condition = details.targetCondition;

    final ActivityStatus completed = _calculateCompletionStatus(
      dailyDone: dailyDone,
      dailyTarget: dailyTarget,
      condition: condition,
      selectedDate: controller.selectedDate.value,
    );

    Color color = Colors.teal;
    return _baseActivityCard(
      context,
      title: activity.title,
      iconData: Icons.mosque,
      color: color,
      status: completed,
      chips: [
        _buildStatChip(context, '$dailyDone/$dailyTarget', color),
        _buildStatChip(context, '$totalDone/$totalDebt', color),
      ],
      // TODO: bu diyalog düzelecek
      onTap: () => controller.openUpdateDialog(
        context,
        activity: activity,
        currentDailyDone: dailyDone,
        dailyTarget: dailyTarget,
        condition: condition,
      ),
    );
  }

  Widget fastingActivityItem({required ActivityModel activity}) {
    return SizedBox.shrink(); // TODO: Implement fasting activity item
  }

  Widget dhikrActivityItem({required ActivityModel activity}) {
    return SizedBox.shrink(); // TODO: Implement dhikr activity item
  }

  Widget quranActivityItem({required ActivityModel activity}) {
    return SizedBox.shrink(); // TODO: Implement quran activity item
  }

  /// Aktivitenin güncel durumunu hesaplar ve döndürür.
  ///
  /// Eğer aktivite tamamlanmışsa [ActivityStatus.completed] döner.
  ///
  /// Aşağıdaki durumlardan biri gerçekleşirse durum [ActivityStatus.failed] olur:
  /// * Seçilen [target] tarihi, [current] tarihten geçmişteyse.
  /// * [condition], [TargetCondition.atMost] ise ve [dailyDone] miktarı [dailyTarget] değerini aştıysa.
  /// * [condition], [TargetCondition.exact] ise ve [dailyDone] miktarı [dailyTarget] değerini aştıysa.
  ///
  /// Yukarıdaki şartlar sağlanmazsa, aktivite [ActivityStatus.pending] olarak kalır.
  ActivityStatus _calculateCompletionStatus({
    required int dailyDone,
    required int dailyTarget,
    required TargetCondition condition,
    required DateTime? selectedDate,
  }) {
    if (condition.checkCompletion(done: dailyDone, target: dailyTarget)) {
      return ActivityStatus.completed;
    }

    if (selectedDate!.onlyDate.compareTo(DateTime.now().onlyDate) < 0 ||
        (condition == TargetCondition.atMost && dailyDone > dailyTarget) ||
        (condition == TargetCondition.exact && dailyDone > dailyTarget)) {
      return ActivityStatus.failed;
    } else {
      return ActivityStatus.pending;
    }
  }

  // liste elemanları için ortak kart tasarımı
  Widget _baseActivityCard(
    BuildContext context, {
    required String title,
    required IconData iconData,
    required Color color,
    required ActivityStatus status,
    required List<Widget> chips,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SOL: İkon Kutusu
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, color: Colors.white, size: 23),
            ),

            const SizedBox(width: 14),

            // ORTA BÖLÜM: Başlık ve Çipler
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: context.theme.textTheme.titleMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: context.theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: chips,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // SAĞ BÖLÜM: Durum Çemberi ve 3 Nokta Menüsü
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status.bgColor,
                    border: Border.all(color: status.color, width: 1.5),
                  ),
                  child: Icon(status.icon, color: status.color, size: 16),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // Menü tetikleyicisi
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Listedeki aktiviteler için istatistik çipleri oluşturur ( 0/5 gibi )
  Widget _buildStatChip(BuildContext context, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.secondaryContainer.withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: context.theme.textTheme.labelSmall?.fontSize,
          fontWeight: context.theme.textTheme.labelSmall?.fontWeight,
          color: color,
        ),
      ),
    );
  }
}
