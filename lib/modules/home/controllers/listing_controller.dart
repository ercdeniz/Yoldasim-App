import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/models/activity_record.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';

/// Aktivite listeleme ve günlük ilerleme kaydı ile ilgili işlemleri yöneten kontrolcü
class ListingController extends GetxController {
  final isarService = Get.find<IsarService>();
  CalendarController get calendarController => Get.find<CalendarController>();

  /// Aktivite listesi
  var activities = <ActivityModel>[].obs;

  /// Ekranda gösterilecek günlük veriler.
  var dailyDoneCounts = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    activities.bindStream(isarService.listenToActivities());
  }

  /// Aktivitenin güncel ilerlemesini hesaplar ve döndürür.
  /// Aktiviteyi güncellemek için açılan diyalogda, kullanıcının girdiği yeni günlük tamamlanan sayısını kaydeder.
  /// [activity] : Güncellenmek istenen aktivite
  /// [newDailyDone] : Kullanıcının girdiği yeni günlük tamamlanan sayısı
  /// [oldDailyDone] : Güncelleme öncesi günlük tamamlanan sayısı
  Future<String?> saveActivityProgress(
    ActivityModel activity,
    int newDailyDone,
    int oldDailyDone,
  ) async {
    try {
      final int difference = newDailyDone - oldDailyDone;

      if (difference == 0) return null;

      final targetDate = calendarController.selectedDate.value.onlyDate;

      await isarService.db.writeTxn(() async {
        var record = await isarService.db.activityRecords
            .filter()
            .activityIdEqualTo(activity.id)
            .dateEqualTo(targetDate)
            .findFirst();

        if (record == null) {
          record = ActivityRecord()
            ..activityId = activity.id
            ..date = targetDate
            ..doneCount = newDailyDone;
        } else {
          record.doneCount = newDailyDone;
        }
        await isarService.db.activityRecords.put(record);

        switch (activity.type) {
          case ActivityType.salah:
            _processSalahDetails(activity, difference);
          case ActivityType.fasting:
          // TODO: burayı doldur
          case ActivityType.dhikr:
          // TODO: burayı doldur
          case ActivityType.quran:
          // TODO: burayı doldur
        }
        await isarService.db.activityModels.put(activity);
      });

      await calendarController.getDailyRecordsForDate();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void _processSalahDetails(ActivityModel activity, int difference) {
    if (activity.salahDetails != null) {
      activity.salahDetails!.totalDone += difference;
      if (activity.salahDetails!.totalDone < 0) {
        activity.salahDetails!.totalDone = 0;
      }
    }
  }

  /// Aktivitenin güncel durumunu hesaplar ve döndürür.
  ///
  /// Eğer aktivite tamamlanmışsa [ActivityStatus.completed] döner.
  ///
  /// Aşağıdaki durumlardan biri gerçekleşirse durum [ActivityStatus.failed] olur:
  /// Şu şartlardan biri gerçekleşirse aktivite başarısız sayılır:
  /// * [condition], [TargetCondition.atMost] ise ve [dailyDone] miktarı [dailyTarget] değerini aştıysa.
  /// * [condition], [TargetCondition.exact] ise ve [dailyDone] miktarı [dailyTarget] değerini aştıysa.
  /// * Seçilen [target] tarihi, [current] tarihten geçmişteyse ve [isDailyMandatory] zorunlu ise.
  ///
  /// Yukarıdaki şartlar sağlanmazsa, aktivite [ActivityStatus.partial] olarak kalır.
  ActivityStatus calculateCompletionStatus({
    required int dailyDone,
    required int dailyTarget,
    required TargetCondition condition,
    required DateTime? selectedDate,
    required bool isDailyMandatory,
  }) {
    if (condition.checkCompletion(done: dailyDone, target: dailyTarget)) {
      return ActivityStatus.completed;
    }

    if ((condition == TargetCondition.atMost && dailyDone > dailyTarget) ||
        (condition == TargetCondition.exact && dailyDone > dailyTarget)) {
      return ActivityStatus.failed;
    }

    if (selectedDate!.onlyDate.compareTo(DateTime.now().onlyDate) < 0) {
      return isDailyMandatory ? ActivityStatus.failed : ActivityStatus.pending;
    } else {
      return ActivityStatus.partial;
    }
  }

  /// Aktivite silme işlemi
  /// [activityId] : Silinecek aktivitenin ID'si
  /// Dönen değer: Eğer silme işlemi başarılıysa null, aksi takdirde hata mesajı döner.
  Future<String?> deleteActivity(int activityId) async {
    try {
      await isarService.deleteActivity(activityId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
