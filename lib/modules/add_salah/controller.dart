import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';

typedef C = AppConstants;

class AddSalahController extends GetxController {
  // Seçilen namaz vakti (Arayüzde gösterilecek metin)
  var selectedTimeText = C.activity.selectTimePlaceholder.obs;
  // Seçilen asıl enum değeri
  var selectedTime = Rxn<SalahTime>();

  // Hedef Koşulu (En az, Tam, En fazla)
  var selectedTargetCondition = TargetCondition.atLeast.obs;

  // Rakam girişleri
  var totalDebt = ''.obs;
  var dailyTarget = ''.obs;

  // Zorunluluk durumu
  var isMandatory = false.obs;

  // Hata kontrolü
  var isTotalDebtEmpty = false.obs;
  var isDailyTargetEmpty = false.obs;

  var selectedStartDate = DateTime.now().obs;

  // --- SAVE FONKSİYONU ---
  Future<String?> saveActivity() async {
    final validationError = _validateInputs();
    if (validationError != null) {
      return validationError;
    }

    try {
      final newActivity = ActivityModel()
        ..title = selectedTimeText.value
        ..targetCondition = selectedTargetCondition.value
        ..type = ActivityType.salah
        ..period = ActivityPeriod.daily
        ..startDate = selectedStartDate.value
        ..isMandatory = isMandatory.value
        ..salahDetails = (SalahDetails()
          ..salahTime = selectedTime.value!
          ..totalDebt = int.tryParse(totalDebt.value) ?? 0
          ..dailyTarget = int.tryParse(dailyTarget.value) ?? 0
          ..targetCondition = selectedTargetCondition.value);

      await Get.find<IsarService>().saveActivity(newActivity);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  String? _validateInputs() {
    isTotalDebtEmpty.value = totalDebt.value.trim().isEmpty;
    isDailyTargetEmpty.value = dailyTarget.value.trim().isEmpty;
    final bool isTimeMissing = selectedTime.value == null;

    List<String> errorMessages = [];

    if (isTimeMissing) {
      errorMessages.add(C.activity.errSelectTime);
    }
    if (isTotalDebtEmpty.value) {
      errorMessages.add(C.activity.errTotalDebtEmpty);
    }
    if (isDailyTargetEmpty.value) {
      errorMessages.add(C.activity.errDailyTargetEmpty);
    }

    if (errorMessages.isNotEmpty) {
      return errorMessages.join('\n');
    }

    return null;
  }
}
