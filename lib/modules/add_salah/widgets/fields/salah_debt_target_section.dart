import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_salah/controller.dart';
import 'package:yoldasim_app/modules/add_salah/widgets/pickers/condition_picker_button.dart';
import 'package:yoldasim_app/widgets/inputs/number_input_field.dart';

typedef C = AppConstants;

class SalahDebtTargetSection extends GetView<AddSalahController> {
  const SalahDebtTargetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // TOPLAM BORÇ GİRİŞİ
          NumberInputField(
            label: C.activity.salahTotalDebt,
            hint: 'Örn: 300',
            requirement: FieldRequirement.mandatory,
            onChanged: (value) => controller.totalDebt.value = value,
            isError: controller.isTotalDebtEmpty,
          ),
          // GÜNLÜK HEDEF GİRİŞİ
          NumberInputField(
            label: C.activity.dailyTarget,
            hint: 'Örn: 5',
            requirement: FieldRequirement.mandatory,
            onChanged: (value) => controller.dailyTarget.value = value,
            isError: controller.isDailyTargetEmpty,
            trailing: const ConditionPickerButton(),
          ),
        ],
      ),
    );
  }
}