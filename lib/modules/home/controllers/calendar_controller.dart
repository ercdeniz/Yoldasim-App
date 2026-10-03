import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/data/models/activity_record.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';

typedef C = AppConstants;

class CalendarController extends GetxController {
  final isarService = Get.find<IsarService>();
  ListingController get listingController => Get.find<ListingController>();

  /// Tarih şeridinin pozisyonunu yönetecek kontrolcü
  final itemScrollController = ScrollController();

  /// Seçili tarih
  /// Takvim şeridinde veya alttan açılan takvimde seçili olan tarih
  var selectedDate = DateTime.now().obs;

  /// Şeritte gösterilecek günlerin listesi (Reaktif)
  var dateList = <DateTime>[].obs;

  /// Takvim şeridi UI ile ilgili sabitler
  static const double dateStripHeight = 65.0;
  static const double dateItemWidth = 48.0;
  static const double dateItemMargin = 8.0;
  static const double dateStripLeftPadding = 16.0;

  @override
  void onInit() {
    super.onInit();
    generateDateList(selectedDate.value);
    scrollToCenter();
  }

  /// Verilen referans tarihe göre 30 gün önce ve 30 gün sonrasını hesaplar
  /// 61 günlük bir liste oluşturuyoruz (30 geçmiş + 1 bugün + 30 gelecek)
  void generateDateList(DateTime referenceDate) {
    dateList.value = List.generate(
      61,
      (index) => referenceDate.subtract(Duration(days: 30 - index)),
    );
  }

  /// Tarih şeridinden bir güne tıklandığında gün seçilir. (Şerit kaymaz, sadece seçilir)
  void selectDateFromStrip(DateTime date) {
    selectedDate.value = date;
    getDailyRecordsForDate();
  }

  /// Alttan açılan takvimden tıklandığında gün seçilir. (Şerit o güne göre baştan dizilir)
  void selectDateFromCalendar(DateTime date) {
    selectedDate.value = date;
    generateDateList(date);
    scrollToCenter();
  }

  /// Alttan açılan takvimde "Bugün" butonuna basıldığında bugünün tarihi seçilir ve şerit bugüne göre baştan dizilir.
  void jumpToToday() {
    final today = DateTime.now();
    selectedDate.value = today;
    generateDateList(today);
    scrollToCenter();
  }

  /// Seçilen tarihi ortalar
  void scrollToCenter() {
    getDailyRecordsForDate();

    Future.delayed(const Duration(milliseconds: 50), () {
      if (itemScrollController.hasClients) {
        final screenWidth = Get.width;
        const totalItemWidth = dateItemWidth + dateItemMargin;

        final selectedIndex = dateList.indexWhere(
          (date) => date.onlyDate == selectedDate.value.onlyDate,
        );
        final targetIndex = selectedIndex != -1 ? selectedIndex : 30;

        final itemStartPosition =
            (targetIndex * totalItemWidth) + dateStripLeftPadding;

        final targetPosition =
            itemStartPosition - (screenWidth / 2) + (dateItemWidth / 2);

        final maxScroll = itemScrollController.position.maxScrollExtent;
        final clampedPosition = targetPosition.clamp(0.0, maxScroll);

        itemScrollController.animateTo(
          clampedPosition,
          duration: Duration(milliseconds: C.common.animationDuration),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Takvimden seçili günün kayıtlarını veritabanından çeker
  Future getDailyRecordsForDate({int? activityId}) async {
    final targetDate = selectedDate.value.onlyDate;

    final records = await isarService.db.activityRecords
        .filter()
        .dateEqualTo(targetDate)
        .findAll();

    final Map<int, int> newMap = {};
    for (var record in records) {
      newMap[record.activityId] = record.doneCount;
    }
    listingController.dailyDoneCounts.value = newMap;
    await listingController.refreshPeriodDoneCounts(activityId: activityId);
  }

  /// APPBAR BAŞLIK FORMATLAYICI
  /// Tarihi "Eyl 11, 2026" şeklinde formatlar.
  String formatAppBarTitle(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return C.common.today;
    }
    return DateFormat('MMM d, yyyy', 'tr_TR').format(date);
  }
}
