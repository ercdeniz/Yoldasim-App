import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/models/activity_record.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';
import 'package:yoldasim_app/data/services/activity_schedule_service.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';

/// Aktivite listeleme ve günlük ilerleme kaydı ile ilgili işlemleri yöneten kontrolcü
class ListingController extends GetxController {
  final isarService = Get.find<IsarService>();
  CalendarController get calendarController => Get.find<CalendarController>();

  /// Aktivite listesi
  var activities = <ActivityModel>[].obs;

  /// Ekranda gösterilecek günlük veriler.
  var dailyDoneCounts = <int, int>{}.obs;

  /// Seçili tarihin içinde bulunduğu periyottaki toplam ilerlemeler.
  var periodDoneCounts = <int, int>{}.obs;

  String? _lastScheduleSignature;

  @override
  void onInit() {
    super.onInit();
    activities.bindStream(isarService.listenToActivities());
    ever(activities, (_) {
      final signature = _scheduleSignature();
      if (signature == _lastScheduleSignature) return;

      _lastScheduleSignature = signature;
      refreshPeriodDoneCounts();
    });
  }

  /// Seçili tarihe göre periyodik aktivite ilerlemelerini günceller.
  Future<void> refreshPeriodDoneCounts({int? activityId}) async {
    final selectedDate = calendarController.selectedDate.value;
    final nextCounts = activityId == null
        ? <int, int>{}
        : Map<int, int>.from(periodDoneCounts);
    final activitiesToRefresh = activityId == null
        ? activities.toList()
        : activities.where((activity) => activity.id == activityId);

    for (final activity in activitiesToRefresh) {
      final range = ActivityScheduleService.periodRange(
        activity.period,
        selectedDate,
      );
      final records = await isarService.db.activityRecords
          .filter()
          .activityIdEqualTo(activity.id)
          .dateBetween(range.start, range.end, includeUpper: false)
          .findAll();
      nextCounts[activity.id] = records.fold(
        0,
        (total, record) => total + record.doneCount,
      );
    }

    periodDoneCounts.value = nextCounts;
  }

  /// Aktivite planının değişip değişmediğini kontrol etmek için bir imza oluşturur.
  String _scheduleSignature() {
    return activities
        .map(
          (activity) => [
            activity.id,
            activity.period.index,
            activity.startDate.millisecondsSinceEpoch,
            activity.schedule.weeklyDays.join(','),
            activity.schedule.monthlyDays.join(','),
          ].join(':'),
        )
        .join('|');
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

        activity.totalDone += difference;
        if (activity.totalDone < 0) {
          activity.totalDone = 0;
        }
        await isarService.db.activityModels.put(activity);
      });

      await calendarController.getDailyRecordsForDate(activityId: activity.id);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Günlük aktivitenin güncel durumunu hesaplar.
  /// [calculatePeriodCompletionStatus] ile farkı şudur:
  /// Bu fonksiyon, sadece günlük aktivitenin durumunu hesaplar
  /// Bunun için [periodEnd] parametresi, seçili günün bir sonraki günü olarak belirlenir.
  ActivityStatus calculateCompletionStatus({
    required int dailyDone,
    required int dailyTarget,
    required TargetCondition condition,
    required DateTime? selectedDate,
    required bool isMandatory,
  }) {
    final targetDate = selectedDate!.onlyDate;
    return _calculateCompletionStatusCore(
      done: dailyDone,
      target: dailyTarget,
      condition: condition,
      periodEnd: targetDate.add(const Duration(days: 1)),
      isMandatory: isMandatory,
    );
  }

  /// Periyodik veya tüm zamanlı aktivitenin güncel durumunu hesaplar.
  /// [calculateCompletionStatus] ile farkı şudur:
  /// Aktivitenin periyodunun bitiş tarihini dikkate alır ve periyodik ilerlemeyi değerlendirir.
  ActivityStatus calculatePeriodCompletionStatus({
    required int periodDone,
    required int periodTarget,
    required TargetCondition condition,
    required DateTime selectedDate,
    required DateTime periodEnd,
    required bool isMandatory,
    required bool isOpenEnded,
  }) {
    return _calculateCompletionStatusCore(
      done: periodDone,
      target: periodTarget,
      condition: condition,
      periodEnd: periodEnd,
      isMandatory: isMandatory,
      isOpenEnded: isOpenEnded,
    );
  }

  /// Aktivitenin (Günlük veya Dönemsel) güncel durumunu hesaplayan ana mekanizma.
  ///
  /// Eğer hedeflenen miktar başarıyla tamamlanmışsa [ActivityStatus.completed] döner.
  ///
  /// Aşağıdaki durumlardan biri gerçekleşirse durum [ActivityStatus.failed] olur:
  /// * [condition], [TargetCondition.atMost] ise ve yapılan [done] miktarı [target] değerini aştıysa.
  /// * [condition], [TargetCondition.exact] ise ve yapılan [done] miktarı [target] değerini aştıysa.
  /// * Aktivite periyodu/günü bitmişse ([periodEnd] tarihi geçildiyse) ve aktivite [isMandatory] (zorunlu) ise.
  ///
  /// Eğer aktivite süresi/periyodu bitmiş, hedef tamamlanmamış ve [isMandatory] zorunlu değilse, durum [ActivityStatus.pending] olur.
  ///
  /// Yukarıdaki şartların hiçbiri sağlanmazsa (süre henüz bitmediyse ve hedef aşılmadıysa), aktivite [ActivityStatus.partial] olarak kalır.
  ActivityStatus _calculateCompletionStatusCore({
    required int done,
    required int target,
    required TargetCondition condition,
    required DateTime periodEnd,
    required bool isMandatory,
    required bool isOpenEnded,
  }) {
    if (condition.checkCompletion(done: done, target: target)) {
      return ActivityStatus.completed;
    }

    if (isOpenEnded) {
      return ActivityStatus.partial;
    }

    final exceedsTarget =
        (condition == TargetCondition.atMost && done > target) ||
        (condition == TargetCondition.exact && done > target);
    if (exceedsTarget) {
      return ActivityStatus.failed;
    }

    final hasEnded = !DateTime.now().onlyDate.isBefore(periodEnd.onlyDate);
    if (hasEnded) {
      return isMandatory ? ActivityStatus.failed : ActivityStatus.pending;
    }

    return ActivityStatus.partial;
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
