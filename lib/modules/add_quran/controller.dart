import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';

typedef C = AppConstants;

class AddQuranController extends GetxController {
  var selectedTargetType = QuranTargetType.page.obs;
  var selectedJuzNumbers = <int>[].obs;
  var selectedSurahNumber = 0.obs;
  var targetValue = ''.obs;
  var selectedPeriod = ActivityPeriod.daily.obs;
  var selectedTargetCondition = TargetCondition.atLeast.obs;
  var isMandatory = false.obs;
  var isTargetEmpty = false.obs;
  var selectedStartDate = DateTime.now().obs;
  var weeklyDays = <int>[].obs;
  var monthlyDays = <int>[].obs;

  String get targetTypeName {
    return selectedTargetType.value.displayName;
  }

  String get selectedContentName {
    switch (selectedTargetType.value) {
      case QuranTargetType.page:
        return '';
      case QuranTargetType.juz:
        return selectedJuzNumbers.isEmpty
            ? C.activity.selectQuranJuz
            : C.activity.selectedQuranJuzCount(selectedJuzNumbers.length);
      case QuranTargetType.surah:
        return selectedSurahNumber.value == 0
            ? C.activity.selectQuranSurah
            : C.activity.quranSurahNames[selectedSurahNumber.value - 1];
    }
  }

  void selectTargetType(QuranTargetType type) {
    selectedTargetType.value = type;
    if (type != QuranTargetType.juz) {
      selectedJuzNumbers.clear();
    }
    if (type != QuranTargetType.surah) {
      selectedSurahNumber.value = 0;
    }
  }

  String get scheduleSummary {
    final selectedDays = selectedPeriod.value == ActivityPeriod.weekly
        ? weeklyDays
        : monthlyDays;
    return selectedDays.isEmpty
        ? C.activity.noDaysSelected
        : C.activity.selectedDaysCount(selectedDays.length);
  }

  Future<String?> saveActivity() async {
    final validationError = _validateInputs();
    if (validationError != null) {
      return validationError;
    }

    try {
      final newActivity = ActivityModel()
        ..title = C.activity.quranTitle
        ..type = ActivityType.quran
        ..period = selectedPeriod.value
        ..targetCondition = selectedTargetCondition.value
        ..startDate = selectedStartDate.value
        ..isMandatory = isMandatory.value
        ..schedule = (ActivitySchedule()
          ..weeklyDays = weeklyDays.toList()
          ..monthlyDays = monthlyDays.toList())
        ..quranDetails = (QuranDetails()
          ..targetType = selectedTargetType.value
          ..targetValue = int.parse(targetValue.value)
          ..selectedJuzNumbers = selectedJuzNumbers.toList()
          ..selectedSurahNumber = selectedSurahNumber.value);

      await Get.find<IsarService>().saveActivity(newActivity);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  String? _validateInputs() {
    isTargetEmpty.value = targetValue.value.trim().isEmpty;
    if (isTargetEmpty.value) {
      return C.activity.errQuranTargetEmpty;
    }

    if ((int.tryParse(targetValue.value) ?? 0) <= 0) {
      return C.activity.errQuranTargetEmpty;
    }

    if (selectedPeriod.value == ActivityPeriod.weekly && weeklyDays.isEmpty) {
      return C.activity.errScheduleWeeklyEmpty;
    }
    if (selectedPeriod.value == ActivityPeriod.monthly && monthlyDays.isEmpty) {
      return C.activity.errScheduleMonthlyEmpty;
    }

    switch (selectedTargetType.value) {
      case QuranTargetType.page:
        break;
      case QuranTargetType.juz:
        if (selectedJuzNumbers.isEmpty) {
          return C.activity.errQuranJuzEmpty;
        }
      case QuranTargetType.surah:
        if (selectedSurahNumber.value == 0) {
          return C.activity.errQuranSurahEmpty;
        }
    }

    return null;
  }
}
