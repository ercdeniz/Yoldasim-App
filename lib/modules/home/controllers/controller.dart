import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/models/activity_record.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';

class HomeController extends GetxController {
  final IsarService isarService = Get.find<IsarService>();

/// TODO: takvimle alakalı olanları [CalendarController] içine al



  // Tarih şeridinin pozisyonunu yönetecek kontrolcü
  final itemScrollController = ScrollController();

  // seçili sayfa indexi
  var currentIndex = 0.obs;

  // Seçili gün
  var selectedDate = DateTime.now().obs;

  // Şeritte gösterilecek günlerin listesi (Reaktif)
  var dateList = <DateTime>[].obs;

  // Aktivite listesi
  var activities = <ActivityModel>[].obs;

  // Ekranda gösterilecek günlük veriler.
  // Tip: Sözlük (Map). Anahtar: Aktivite ID (int), Değer: Tamamlanan Sayı (int)
  var dailyDoneCounts = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _generateDateList(selectedDate.value);
    scrollToCenter();
    activities.bindStream(isarService.listenToActivities());
  }

  // Verilen referans tarihe göre ~30 gün önce ve ~30 gün sonrasını hesaplar
  void _generateDateList(DateTime referenceDate) {
    // 61 günlük bir liste oluşturuyoruz (30 geçmiş + 1 bugün + 30 gelecek)
    dateList.value = List.generate(
      61,
      (index) => referenceDate.subtract(Duration(days: 30 - index)),
    );
  }

  // 1. Durum: Sadece yatay şeritten bir güne tıklandığında (Şerit kaymaz, sadece seçilir)
  void selectDateFromStrip(DateTime date) {
    selectedDate.value = date;
    getDailyRecordsForDate();
  }

  // 2. Durum: Alttan açılan takvimden tıklandığında (Şerit o güne göre baştan dizilir)
  void selectDateFromCalendar(DateTime date) {
    selectedDate.value = date;
    _generateDateList(date); // Seçilen günü merkeze al
    scrollToCenter(); // Seçilen karta otomatik odaklan
  }

  // "Bugün" butonuna basıldığında
  void jumpToToday() {
    final today = DateTime.now();
    selectedDate.value = today;
    _generateDateList(today);
    scrollToCenter(); // Seçilen karta otomatik odaklan
  }

  // tıklanan sayfaya geçiş yap
  void changePage(int index) {
    currentIndex.value = index;
  }

  // seçilen tarihi ortalar ve sağında solunda 30 gün olacak şekilde şeridi ayarlar
  void scrollToCenter() {
    getDailyRecordsForDate(); // Seçilen tarihe ait günlük kayıtları getir
    Future.delayed(const Duration(milliseconds: 50), () {
      if (itemScrollController.hasClients) {
        final screenWidth = Get.width;

        const itemWidth = 48.0; // Kartın kendi genişliği
        const margin = 8.0; // Kartlar arası boşluk
        const totalItemWidth = itemWidth + margin;

        const leftPadding = 16.0;

        // 30. elemanın başlangıç noktası = (kendinden önceki 30 kartın genişliği) + (sol padding)
        final itemStartPosition = (30 * totalItemWidth) + leftPadding;

        // Kartın tam ortasını, ekranın tam ortasına getiren kesin formül
        final targetPosition =
            itemStartPosition - (screenWidth / 2) + (itemWidth / 2);

        itemScrollController.jumpTo(targetPosition);
      }
    });
  }

  // Takvimden seçili günün kayıtlarını veritabanından çeker
  Future getDailyRecordsForDate() async {
    final targetDate = selectedDate.value.onlyDate;

    final records = await isarService.db.activityRecords
        .filter()
        .dateEqualTo(targetDate)
        .findAll();

    final Map<int, int> newMap = {};
    for (var record in records) {
      newMap[record.activityId] = record.doneCount;
    }
    dailyDoneCounts.value = newMap;
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
    final targetDate = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
    );

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
    await getDailyRecordsForDate();
  }

  // TODO: bu görsel olarak düzenlenecek tema da bozuk
  // listele elemanlarına tıklandığında çalışacak diyalog
  void openUpdateDialog(
    BuildContext context, {
    required ActivityModel activity,
    required int currentDailyDone, // Ekranda hazır olan sayıyı alacak
    required int dailyTarget, // Hedef yazısı için
    required TargetCondition condition, // tamamlanma şartı için
  }) {
    // Diyalog açıldığında sayaç sıfırdan değil, kullanıcının o güne kadar yaptığı sayıdan başlar
    int counter = currentDailyDone;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(
                0xFF1E1E1E,
              ), // Görseldeki koyu gri zemin
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Center(
                child: Text(
                  'Hedefi Güncelle',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Siyah Kutu (Sayaç Alanı)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black, // Görseldeki iç siyah kutu
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
                              if (counter > 0) setState(() => counter--);
                            },
                            icon: const Icon(Icons.remove, color: Colors.black),
                          ),
                        ),
                        // Ortadaki Dev Rakam
                        Text(
                          '$counter',
                          style: const TextStyle(
                            fontSize: 56,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Artı Butonu
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.cyan,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => setState(() => counter++),
                            icon: const Icon(Icons.add, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Alt Bilgi Yazısı
                  Text(
                    'Hedef: ${condition.getText} $dailyTarget',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Iptal',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    saveActivityProgress(
                      activity,
                      counter, // Diyalogdaki yeni sayı
                      currentDailyDone, // Diyalog açılmadan önceki sayı
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Guncelle',
                    style: TextStyle(color: Colors.cyan, fontSize: 18),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
