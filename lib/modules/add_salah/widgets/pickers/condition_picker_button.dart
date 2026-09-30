import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_salah/controller.dart';
import 'package:yoldasim_app/widgets/picker/condition_picker_sheet.dart';

class ConditionPickerButton extends GetView<AddSalahController> {
  const ConditionPickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppConditionPickerSheet.show(
          initialCondition: controller.selectedTargetCondition.value,
          onConditionSelected: (condition) {
            controller.selectedTargetCondition.value = condition;
          },
        );
      },

      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.selectedTargetCondition.value.displayName,
                style: TextStyle(color: context.primary),
              ),
              Icon(Icons.keyboard_arrow_down, color: context.primary),
            ],
          ),
        ),
      ),
    );
  }
}
