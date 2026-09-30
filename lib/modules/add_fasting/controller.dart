import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';

typedef C = AppConstants;

class AddFastingController extends GetxController {
  /// Toplam borç miktarı
	var totalDebt = ''.obs;

  /// Günlük zorunluluk durumu
	var isDailyMandatory = false.obs;

  /// Hata kontrolü
	var isTotalDebtEmpty = false.obs;

  /// Başlangıç tarihi
	var selectedStartDate = DateTime.now().obs;

	Future<String?> saveActivity() async {
		final validationError = _validateInputs();
		if (validationError != null) {
			return validationError;
		}

		try {
			final newActivity = ActivityModel()
				..title = C.activity.fastingTitle
				..type = ActivityType.fasting
				..period = ActivityPeriod.daily
				..startDate = selectedStartDate.value
				..isDailyMandatory = isDailyMandatory.value
				..fastingDetails = (FastingDetails()
					..totalDebt = int.parse(totalDebt.value)
					..totalDone = 0);

			await Get.find<IsarService>().saveActivity(newActivity);
			return null;
		} catch (e) {
			return e.toString();
		}
	}

	String? _validateInputs() {
		isTotalDebtEmpty.value = totalDebt.value.trim().isEmpty;

		if (isTotalDebtEmpty.value) {
			return C.activity.errFastingTotalDebtEmpty;
		}

		return null;
	}
}
