import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';

typedef C = AppConstants;

class AddSalahController extends GetxController {
  // Seçilen namaz vakti (Arayüzde gösterilecek metin)
  var selectedTimeText = 'Vakit Seçin'.obs;
  // Seçilen asıl enum değeri
  var selectedTime = Rxn<SalahTime>();

  // Namaz vakitlerini ve karşılık gelen metinleri tutan bir Map
  final Map _timeNames = {
    SalahTime.fajr: 'Sabah Namazı',
    SalahTime.dhuhr: 'Öğle Namazı',
    SalahTime.asr: 'İkindi Namazı',
    SalahTime.maghrib: 'Akşam Namazı',
    SalahTime.isha: 'Yatsı Namazı',
    SalahTime.witr: 'Vitir Namazı',
  };

  // Hedef Koşulu (En az, Tam, En fazla)
  var selectedTargetCondition = TargetCondition.atLeast.obs;

  // Hedef Koşulu metinleri
  final Map targetConditionNames = const {
    TargetCondition.atLeast: 'En Az',
    TargetCondition.exact: 'Tam Olarak',
    TargetCondition.atMost: 'En Çok',
  };

  // Rakam girişleri
  var totalDebt = ''.obs;
  var dailyTarget = ''.obs;

  // Zorunluluk durumu
  var isDailyMandatory = false.obs;

  // Hata kontrolü
  var isTotalDebtEmpty = false.obs;
  var isDailyTargetEmpty = false.obs;

  var selectedStartDate = DateTime.now().obs;

  // VALIDATION FONKSİYONU
  bool _validateInputs() {
    isTotalDebtEmpty.value = totalDebt.value.trim().isEmpty;
    isDailyTargetEmpty.value = dailyTarget.value.trim().isEmpty;
    final bool isTimeMissing = selectedTime.value == null;

    List errorMessages = [];

    if (isTimeMissing) {
      errorMessages.add('• Lütfen bir namaz vakti seçin.');
    }
    if (isTotalDebtEmpty.value) {
      errorMessages.add('• Toplam kaza borcunu girin.');
    }
    if (isDailyTargetEmpty.value) {
      errorMessages.add('• Günlük hedef miktarını girin.');
    }

    if (errorMessages.isNotEmpty) {
      Get.snackbar(
        C.validation.requirementError.title,
        errorMessages.join('\n'),
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        duration: const Duration(seconds: 2),
      );
      return false;
    }

    return true;
  }

  // --- SAVE FONKSİYONU ---
  Future<void> saveActivity() async {
    if (!_validateInputs()) return;

    //Modeli Oluştur
    final newActivity = ActivityModel()
      ..title = selectedTimeText.value
      ..targetCondition = selectedTargetCondition.value
      ..type = ActivityType.salah
      ..period = ActivityPeriod.daily
      ..startDate = selectedStartDate.value
      ..isDailyMandatory = isDailyMandatory.value
      ..salahDetails = (SalahDetails()
        ..salahTime = selectedTime.value!
        ..totalDebt = int.tryParse(totalDebt.value) ?? 0
        ..dailyTarget = int.tryParse(dailyTarget.value) ?? 0
        ..targetCondition = selectedTargetCondition.value
        ..totalDone = 0);

    // Veritabanına Kaydet
    final isarService = Get.find<IsarService>();
    await isarService.saveActivity(newActivity);

    // Başarı mesajı ve sayfayı kapat
    Get.back(); // Önceki sayfaya dön
    Get.snackbar(
      'Başarılı',
      '${selectedTimeText.value} kazası başarıyla oluşturuldu.',
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      colorText: Colors.green,
    );
  }

  // --- BOTTOM SHEET (VAKİT SEÇİCİ) ---
  void showTimePickerSheet(BuildContext context) {
    Get.bottomSheet(
      Material(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Üstteki tutma çubuğu (Drag handle)
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Namaz Vakti Seçin',
                  style: context.theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Seçenekleri Map üzerinden döngüyle oluşturuyoruz
                ..._timeNames.entries.map((entry) {
                  return Obx(
                    () => ListTile(
                      title: Text(
                        entry.value,
                        style: TextStyle(
                          // Seçiliyse metni kalın ve birincil renk yap
                          fontWeight: selectedTime.value == entry.key
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedTime.value == entry.key
                              ? context.theme.primaryColor
                              : null,
                        ),
                      ),
                      // Seçiliyse sağ tarafa tik işareti koy
                      trailing: selectedTime.value == entry.key
                          ? Icon(
                              Icons.check_circle,
                              color: context.theme.primaryColor,
                            )
                          : null,
                      onTap: () {
                        selectedTime.value = entry.key; // Enum değerini ata
                        selectedTimeText.value = entry.value; // Metni ata
                        Get.back();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // --- HEDEF KOŞULU SEÇİCİ (BOTTOM SHEET) ---
  void showConditionPickerSheet(BuildContext context) {
    Get.bottomSheet(
      Material(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                  child: Text(
                    'Hedef Koşulu',
                    style: context.theme.textTheme.titleLarge,
                  ),
                ),

                // Enum değerlerini listele
                ...TargetCondition.values.map((condition) {
                  return ListTile(
                    title: Text(
                      targetConditionNames[condition]!,
                      style: TextStyle(
                        fontWeight: selectedTargetCondition.value == condition
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selectedTargetCondition.value == condition
                            ? context.theme.primaryColor
                            : null,
                      ),
                    ),
                    trailing: selectedTargetCondition.value == condition
                        ? Icon(
                            Icons.check_circle,
                            color: context.theme.primaryColor,
                          )
                        : null,
                    onTap: () {
                      selectedTargetCondition.value = condition;
                      Get.back();
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // --- TAKVİM DİYALOĞU ---
  Future<void> pickStartDate(BuildContext context) async {
    final Color textColor = context.textTheme.bodyLarge?.color ?? Colors.black;
    final Color passiveTextColor = Colors.grey.shade400;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Obx(
          () => AlertDialog(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            contentPadding: const EdgeInsets.all(12.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TableCalendar(
                    locale: 'tr_TR',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2050, 12, 31),
                    focusedDay: selectedStartDate.value,
                    currentDay: DateTime.now(),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    selectedDayPredicate: (day) =>
                        isSameDay(selectedStartDate.value, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      selectedStartDate.value = selectedDay;
                      Get.back();
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: textColor,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: textColor,
                      ),
                      titleTextStyle: TextStyle(
                        fontSize: context.theme.textTheme.titleLarge!.fontSize,
                        fontWeight:
                            context.theme.textTheme.titleLarge!.fontWeight,
                        color: textColor,
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      weekendStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(color: textColor),
                      weekendTextStyle: TextStyle(color: textColor),
                      outsideTextStyle: TextStyle(color: passiveTextColor),
                      todayDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      todayTextStyle: TextStyle(
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
