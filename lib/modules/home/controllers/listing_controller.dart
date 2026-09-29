import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/models/activity_record.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';

class ListingController extends GetxController {
  final isarService = Get.find<IsarService>();
  CalendarController get calendarController => Get.find<CalendarController>();

  // Aktivite listesi
  var activities = <ActivityModel>[].obs;

  // Ekranda gösterilecek günlük veriler.
  // Tip: Sözlük (Map). Anahtar: Aktivite ID (int), Değer: Tamamlanan Sayı (int)
  var dailyDoneCounts = <int, int>{}.obs;
  
  @override
  void onInit() {
    super.onInit();
    activities.bindStream(isarService.listenToActivities());
  }

  // TODO: bu düzenlenecek
  Future saveActivityProgress(
    ActivityModel activity,
    int newDailyDone,
    int oldDailyDone,
  ) async {
    // 1. FARK HESABI
    final int difference = newDailyDone - oldDailyDone;

    // Kullanıcı sayıyı değiştirmeden Güncelle'ye bastıysa veritabanını hiç yorma
    if (difference == 0) return;

    // Saatlerden arındırılmış saf tarihi al
    final targetDate = calendarController.selectedDate.value.onlyDate;

    await isarService.db.writeTxn(() async {
      // 2. GÜNLÜK KAYDI (RECORD) GÜNCELLE
      var record = await isarService.db.activityRecords
          .filter()
          .activityIdEqualTo(activity.id)
          .dateEqualTo(targetDate)
          .findFirst();

      if (record == null) {
        // O gün için ilk defa kayıt giriliyorsa oluştur
        record = ActivityRecord()
          ..activityId = activity.id
          ..date = targetDate
          ..doneCount = newDailyDone; // Direkt yeni sayıyı bas
      } else {
        // Kayıt varsa sayıyı yeni sayıyla ez
        record.doneCount = newDailyDone;
      }
      // Record'u veritabanına yaz
      await isarService.db.activityRecords.put(record);

      // 3. ANA MODELDEKİ 'TOTAL' (TÜM ZAMANLAR) SAYACINI GÜNCELLE
      // Namaz aktivitesi ise namaz detaylarını güncelle
      if (activity.type == ActivityType.salah &&
          activity.salahDetails != null) {
        // Toplam değere FARK'ı ekle (Eğer eksiye basıldıysa fark negatif olacağı için otomatik azalır)
        activity.salahDetails!.totalDone += difference;

        // Güvenlik: Toplam değerin sıfırın altına düşmesini engelle
        if (activity.salahDetails!.totalDone < 0) {
          activity.salahDetails!.totalDone = 0;
        }

        // Ana modeli de veritabanına yaz
        await isarService.db.activityModels.put(activity);
      }
      // Not: İleride Oruç (fasting) veya Zikir eklediğinde buraya "else if (activity.type == ActivityType.fasting)" şeklinde eklemeler yapacaksın.
    });

    // 4. İŞLEM BİTİNCE SÖZLÜĞÜ YENİLE Kİ EKRANDAKİ SAYILAR ANINDA DEĞİŞSİN
    await calendarController.getDailyRecordsForDate();
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
  ActivityStatus calculateCompletionStatus({
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
}
