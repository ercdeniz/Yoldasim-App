import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';

typedef C = AppConstants;

class AddDhikrController extends GetxController {
  var targetCount = ''.obs;
  var arabicText = ''.obs;
  var turkishText = ''.obs;
  var selectedPeriod = ActivityPeriod.daily.obs;
  var selectedTargetCondition = TargetCondition.atLeast.obs;
  var isMandatory = false.obs;
  var isTargetEmpty = false.obs;
  var isArabicTextEmpty = false.obs;
  var selectedStartDate = DateTime.now().obs;
  var weeklyDays = <int>[].obs;
  var monthlyDays = <int>[].obs;

  String get scheduleSummary {
    final selectedDays = selectedPeriod.value == ActivityPeriod.weekly
        ? weeklyDays
        : monthlyDays;
    return selectedDays.isEmpty
        ? C.activity.selectDays
        : C.activity.selectedDaysCount(selectedDays.length);
  }

  Future<String?> saveActivity() async {
    final validationError = _validateInputs();
    if (validationError != null) {
      return validationError;
    }

    try {
      final newActivity = ActivityModel()
        ..title = C.activity.dhikrTitle
        ..type = ActivityType.dhikr
        ..period = selectedPeriod.value
        ..targetCondition = selectedTargetCondition.value
        ..startDate = selectedStartDate.value
        ..isMandatory = isMandatory.value
        ..schedule = (ActivitySchedule()
          ..weeklyDays = weeklyDays.toList()
          ..monthlyDays = monthlyDays.toList())
        ..dhikrDetails = (DhikrDetails()
          ..targetCount = int.parse(targetCount.value)
          ..arabicText = arabicText.value.trim()
          ..turkishText = turkishText.value.trim().isEmpty
              ? null
              : turkishText.value.trim());

      await Get.find<IsarService>().saveActivity(newActivity);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  String? _validateInputs() {
    isTargetEmpty.value = targetCount.value.trim().isEmpty;
    isArabicTextEmpty.value = arabicText.value.trim().isEmpty;

    if (isTargetEmpty.value || (int.tryParse(targetCount.value) ?? 0) <= 0) {
      return C.activity.errDhikrTargetEmpty;
    }
    if (isArabicTextEmpty.value) {
      return C.activity.errDhikrArabicEmpty;
    }
    if (selectedPeriod.value == ActivityPeriod.weekly && weeklyDays.isEmpty) {
      return C.activity.errScheduleWeeklyEmpty;
    }
    if (selectedPeriod.value == ActivityPeriod.monthly && monthlyDays.isEmpty) {
      return C.activity.errScheduleMonthlyEmpty;
    }
    return null;
  }
}
