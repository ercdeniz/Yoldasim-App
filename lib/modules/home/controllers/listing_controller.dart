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

  /// Günlük periyoda sahip aktivitelerin (Namaz, Oruç vb.) seçili tarihteki
  /// tamamlanma durumunu hesaplar.
  ///
  /// Aktivite süresinin sonunu otomatik olarak seçilen günün ertesi gününün
  /// başlangıcı (`targetDate + 1 gün`, 00:00:00) olarak belirler ve süresiz
  /// olduğunu (`isOpenEnded: false`) varsayarak durum kontrolünü
  /// [_calculateCompletionStatusCore] fonksiyonuna devreder.
  ///
  /// * [dailyDone]: Kullanıcının o gün için kaydettiği tamamlanma adedi.
  /// * [dailyTarget]: O gün için ulaşılması beklenen hedef adet.
  /// * [condition]: Hedefin tamamlanma kuralı (`atLeast`, `exact`, `atMost`).
  /// * [selectedDate]: Takvimde o an incelenen ve üzerinde işlem yapılan gün.
  /// * [isMandatory]: Aktivitenin zorunlu olup olmadığı bilgisi.
  ///
  /// Dönüş Değeri: Aktivitenin durumunu ifade eden [ActivityStatus] değeri.
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
      isOpenEnded: false,
    );
  }

  /// Dönemsel (Haftalık, Aylık, Yıllık veya Tüm Zamanlar) aktivitelerin (Kur'an, Zikir vb.)
  /// tamamlanma durumunu hesaplar.
  ///
  /// Günlük hesaplayıcıdan farklı olarak, periyodun bitiş tarihini ([periodEnd])
  /// ve periyodun süresiz olup olmadığını ([isOpenEnded]) dışarıdan dinamik olarak
  /// alır ve değerlendirmeyi [_calculateCompletionStatusCore] fonksiyonuna aktarır.
  ///
  /// * [periodDone]: İlgili periyot aralığında kaydedilen toplam tamamlanma adedi.
  /// * [periodTarget]: İlgili periyot için belirlenmiş hedef miktar.
  /// * [condition]: Hedef kuralı (`atLeast`, `exact`, `atMost`).
  /// * [selectedDate]: Takvimde o an seçili olan tarih.
  /// * [periodEnd]: Periyodun tamamlandığı/sona erdiği sınır tarihi.
  /// * [isMandatory]: Aktivitenin zorunlu olup olmadığı bilgisi.
  /// * [isOpenEnded]: Aktivitenin "Tüm Zamanlar" gibi belirli bir bitiş süresi
  ///   olmayan açık uçlu bir yapıda olup olmadığı bilgisi.
  ///
  /// Dönüş Değeri: Aktivitenin durumunu ifade eden [ActivityStatus] değeri.
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

  /// Aktivite durumunu (Tamamlandı, Başarısız, Kısmi, Bekliyor) hesaplayan çekirdek mekanizma.
  ///
  /// Mantıksal Değerlendirme Sırası:
  /// 1. Hedef tutturulduysa (`condition.checkCompletion`) -> [ActivityStatus.completed]
  /// 2. Süresiz bir aktiviteyse ve hedef tutturulmadıysa -> [ActivityStatus.partial]
  /// 3. Hedef sınırı aşıldıysa (`atMost` veya `exact` kuralı bozulduysa) -> [ActivityStatus.failed]
  /// 4. Aktivite süresi/periyodu bittiyse:
  ///    - Zorunlu (`isMandatory == true`) ise -> [ActivityStatus.failed]
  ///    - Opsiyonel (`isMandatory == false`) ise -> [ActivityStatus.pending]
  /// 5. Süre henüz dolmadıysa ve hedef aşılmadıysa -> [ActivityStatus.partial]
  ///
  /// * [done]: Gerçekleşen işlem adedi (günlük veya periyodik).
  /// * [target]: Ulaşılması gereken hedef miktar.
  /// * [condition]: Karşılaştırma kuralı (`TargetCondition`).
  /// * [periodEnd]: Değerlendirilen zaman aralığının bitiş anı.
  /// * [isMandatory]: Aktivite yapılmadığında başarısız sayılıp sayılmayacağı.
  /// * [isOpenEnded]: Bitiş süresi olmayan aktiviteler için zaman kontrolünü atlama bayrağı.
  ///
  /// Dönüş Değeri: Koşulların sonucuna göre belirlenen [ActivityStatus].
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
