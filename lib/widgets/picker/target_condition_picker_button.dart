import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/widgets/picker/condition_picker_sheet.dart';

class TargetConditionPickerButton extends StatelessWidget {
  final Rx<TargetCondition> condition;

  const TargetConditionPickerButton({
    super.key,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppConditionPickerSheet.show(
        initialCondition: condition.value,
        onConditionSelected: (value) => condition.value = value,
      ),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                condition.value.displayName,
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